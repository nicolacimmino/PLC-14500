use std::env;
use std::io::{Read, Write};
//use std::io::{BufRead, BufReader}
use std::time::Duration;
//use log::error;
//use serialport::{available_ports, SerialPortBuilder};
use std::fs;
use std::fs::File;
use std::str;
use std::io;
use tokio;

fn read_keyboard (
	sender: tokio::sync::mpsc::Sender<String>,
	runtime: tokio::runtime::Handle
) {
	std::thread::spawn(move || {
		let mut keyboard = String::new();
		io::stdin()
            .read_line(&mut keyboard)
            .expect("Failed to read line");
            
        let sender2 = sender.clone();
        
        runtime.spawn(async move {
        	let result = sender2.send(keyboard).await;
        	if let Err(error) = result {
        		println!("read_keyboard send error: {:?}", error);
        	}
        })
	});
}

async fn manage_serial(mut line_receiver: tokio::sync::mpsc::Receiver<String>, filename: &str, port_name: &str) {
	// read in binary file to the variable bin
    let mut f = File::open(&filename).expect("no file found");
    let metadata = fs::metadata(&filename).expect("unable to read metadata");
    let mut bin = vec![0; metadata.len() as usize];
    f.read(&mut bin).expect("buffer overflow");
    
    let mut bin_array: [u8; 256] = [0; 256];
    let mut counter = 0;
    while counter < 256 {
        bin_array[counter] = bin[counter];
        counter += 1;
    }

    // open serial port
    let mut serial_port = serialport::new(port_name, 9600)
        .timeout(Duration::from_millis(1000))
        .open()
        .expect("Failed to open serial port");
        
    // wait for arduino to think about its life
    // rust has a proper sleep function in std::thread::sleep, but it wouldn't work on my architecture.  I'm already too deep into recursive projects for projects, so I'll save looking at sleep for another day
    counter = 0;
    while counter < 2_000_000_000 {
        counter += 1;
    }
		
    // write binary file contents to serial port
    serial_port.write(&bin_array).expect("Write failed!");    
    serial_port.flush().unwrap();
    
    
	loop {
		tokio::select! {
			Some(line) = line_receiver.recv() => {
                println!("line: {}", line);
                match line.as_str() {
                	"X" => {
                		println!("closing monitor");
                		break;
                	},
                	"\n" => {
				        serial_port.write("\r".as_bytes()).expect("Write failed!");
                	}
                	unexpected_line => {
				        serial_port.write(unexpected_line.as_bytes()).expect("Write failed!");
                	}
                }
			}
		}
	}
}

#[tokio::main]
async fn main() {
    let args: Vec<String> = env::args().collect();

    let num_args = args.iter().count();
    let flash_rs_name = &args[0];
    if num_args != 3 {
        println!("Found {num_args} arguments.\nUsage: {flash_rs_name} [file] [port]");
        return;
    }

    let filename = &*args[1];
    let port_name = &*args[2];

    
    let (line_sender, line_receiver) = tokio::sync::mpsc::channel(1);
        read_keyboard(line_sender, tokio::runtime::Handle::current());
        
    manage_serial(line_receiver, filename, port_name).await;
}


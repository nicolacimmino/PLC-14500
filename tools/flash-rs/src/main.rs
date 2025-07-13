use std::env;
use std::fs;
use std::fs::File;
use std::io::{Read, Write};
use serialport::ClearBuffer;
use std::str;
use std::time::Duration;


/// Receive serial data from the Arduino Nano and print it to the terminal.
/// * 'serial_port' - instance of a serialport from the serialport library passed by mutable reference
fn rx_serial(serial_port: &mut Box<dyn serialport::SerialPort> ) {
	let mut getting_data = true;
	let mut delay_tracker = 0;  // makes the program wait for any delayed messages before returning to keyboard monitoring
	
	while getting_data {
	    let mut serial_buf: Vec<u8> = vec![0; 32];
        let _error_var = serial_port.read(serial_buf.as_mut_slice());
        
        // convert raw data into a string
        let reply_str = match str::from_utf8(&serial_buf) {
            Ok(v) => v,
            Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
        };
        
        
        if reply_str != "core::result::Result<usize, std::io::error::Error>" {
	        print!("{}", reply_str);
	        
	        let first_char = reply_str.chars().next().unwrap();
	        if first_char == '\0' {  // If it looks like the message is over, return to keyboard monitoring after looping a few more times in case of a delayed message.
	        	delay_tracker += 1;
	        	if delay_tracker == 3 {
		        	getting_data = false;
	        	}
	        } else {
	        	delay_tracker = 0;
	        }
	        
        } else {  // If an io error is thrown, return to keyboard monitoring.
        	getting_data = false;
        }
    }
    
    // Prevent previous message from being read from the stream and printed again.
    serial_port.clear(ClearBuffer::Input).expect("Failed to discard input buffer")
}


/// Upload a given ROM binary to the PLC14500, and then fall into the interactive monitor.
///
/// Command line arguments:
/// * 'file' - the filepath to a 256 byte ROM filename
/// * 'port' - serial port to communicate with the Arduino Nano, ie: "/dev/ttyUSB0"
fn main() {
	// read in terminal arguments
    let args: Vec<String> = env::args().collect();

    let num_args = args.iter().count();
    let flash_rs_name = &args[0];
    if num_args != 3 {
        println!("Found {num_args} arguments.\nUsage: {flash_rs_name} [file] [port]");
        return;
    }

    let filename = &*args[1];
    let port_name = &*args[2];
    
    // read in binary file to the variable bin
    let mut f = File::open(&filename).expect("no file found");
    let metadata = fs::metadata(&filename).expect("unable to read metadata");
    let mut bin = vec![0; metadata.len() as usize];
    f.read(&mut bin).expect("buffer overflow");
    
    let rom_len = bin.len();
    if rom_len != 256 {
    	println!("Error, ROM is invalid size of {rom_len} bytes.  ROM should be 256 bytes.");
    	return;
    }
    
    // Copy ROM into u8 array for easy upload.
	let mut bin_array: [u8; 256] = [0; 256];
	for counter in 0..rom_len {
        bin_array[counter] = bin[counter];
    }

    // open serial port
    let mut serial_port = serialport::new(port_name, 9600)
        .timeout(Duration::from_millis(1000))
        .open()
        .expect("Failed to open serial port");

    // write ROM binary to serial port
    serial_port.write(&bin_array).expect("Write failed!");    
    serial_port.flush().unwrap();
    
    
    
    // Read back text from Arduino and accept keyboard input for interactive monitor.
    print!("\n");  // for good visuals
    
    loop {
		// Ensure the keyboard variable is empty every loop, so no messages get sent twice.
		let mut keyboard = String::new();
		let input = std::io::stdin();

		// Read and print serial messages from the Arduino.
		rx_serial(&mut serial_port);
		
		// read keyboard input
		input.read_line(&mut keyboard).ok().expect("Failed to read line");
		
		if keyboard == "\n" {  // Translate a blank newline to the format expected by the interactive monitor.
			serial_port.write("\r".as_bytes()).expect("Write failed!");
		} else {
			keyboard = keyboard + "\r";  // PLC14500 looks for carriage return
			
			// debugging code to print keyboard input, making escape characters explicitly shown
//			println!("Keyboard Input: {}", keyboard.escape_debug());

			serial_port.write(keyboard.as_bytes()).expect("Write failed!");
		}
    }
}


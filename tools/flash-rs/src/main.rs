use std::env;
use std::io::{BufRead, BufReader, Read, Write};
use std::time::Duration;
use log::error;
use serialport::available_ports;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.iter().count() != 2 {
        println!("Usage: {} [port] [file]", args[0]);
        return;
    }

    let port_name = &*args[1];

    let mut serial_port = serialport::new(port_name, 9600)
        .timeout(Duration::from_millis(1000))
        .open()
        .expect("Failed to open serial port");

    let output = "\rD 0 10\n".as_bytes();
    serial_port.write(output).expect("Write failed!");
    serial_port.flush().unwrap();
    let mut reader = BufReader::new(serial_port);

    while true {
        let mut my_str = String::new();
        reader.read_line(&mut my_str).unwrap();

        println!("{}", my_str);
    }
}

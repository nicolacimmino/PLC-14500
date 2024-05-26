use std::env;
use std::io::{Read, Write};
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
        .open()
        .expect(&*format!("Failed to open port {}", &*port_name));

    serial_port.write("\n\n".as_bytes()).expect("Cannot write to port.");

    let mut buf: String = "".to_string();

    serial_port.read_to_string(&mut buf)
        .expect("Cannot read from port.");

    println!("{}", buf);
}

// MainWindow is the main form of a compiler for the PLC-14500 board.
//  Copyright (C) 2015 Nicola Cimmino
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see http://www.gnu.org/licenses/.
//
//

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.IO.Ports;

namespace Compiler
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        // We store here 
        byte[] txBuffer = new byte[256];

        public MainWindow()
        {
            InitializeComponent();
        }

        private void buttonProgram_Click(object sender, RoutedEventArgs e)
        {
            // Clear buffer
            for (int ix = 0; ix < txBuffer.Length;ix++ )
            {
                txBuffer[ix] = 0;
            }
            compile();
            program();
        }

        /*
         * Process the input text and compile each line into assembled binary.
         */
        private void compile()
        {
            int address = 0;
            List<String> lines = textSource.Text.Split('\n').ToList<String>();
            foreach (String line in lines)
            {
                List<String> tokens = line.Trim().ToUpper().Split(' ').ToList<String>();

                if(tokens.Count ==0 || tokens[0].StartsWith(";") || tokens[0]=="")
                {
                    continue;
                }

                try
                {
                    switch (tokens[0])
                    {
                        case "NOPO": txBuffer[address] = 0x00; break;
                        case "LD": txBuffer[address] = 0x01; break;
                        case "LDC": txBuffer[address] = 0x02; break;
                        case "AND": txBuffer[address] = 0x03; break;
                        case "ANDC": txBuffer[address] = 0x04; break;
                        case "OR": txBuffer[address] = 0x05; break;
                        case "ORC": txBuffer[address] = 0x06; break;
                        case "XNOR": txBuffer[address] = 0x07; break;
                        case "STO": txBuffer[address] = 0x08; break;
                        case "STOC": txBuffer[address] = 0x09; break;
                        case "IEN": txBuffer[address] = 0x0A; break;
                        case "OEN": txBuffer[address] = 0x0B; break;
                        case "JMP": txBuffer[address] = 0x0C; break;
                        case "RTN": txBuffer[address] = 0x0D; break;
                        case "SKZ": txBuffer[address] = 0x0E; break;
                        case "NOPF": txBuffer[address] = 0x0F; break;
                        default: throw new ArgumentException();
                    }

                    if (tokens.Count > 1 && !tokens[1].StartsWith(";") && tokens[1]!="")
                    {
                        txBuffer[address] += (byte)(int.Parse(tokens[1]) << 4);
                    }
                } catch(Exception)
                {
                    global::System.Windows.MessageBox.Show("Error compiling: " + line);
                    return;
                }
                address++;
            }
        }

        /*
         *  Sends the binary over to the programmer.
         *  The bootloader just expects a block of 256 bytes at the moment.
         */
        private void program()
        {
            SerialPort port = new SerialPort("COM4");
            port.BaudRate = 9600;
            port.Open();
            port.Write(txBuffer, 0, 256);
            port.Close();
        }

        private void Window_SizeChanged(object sender, SizeChangedEventArgs e)
        {

        }
    }
}

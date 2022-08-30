using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;

namespace Read_Info
{
    public partial class Form1 : Form
    {
        public string[] ports;
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            ClosePort();
            sendComendToPort("AT+DEVCONINFO");
            readruslt();
        }

        private void readruslt()
        {
            try
            {
                resultTXT.Text = serialPort1.ReadLine();
            }
            catch (TimeoutException)
            {
                resultTXT.Text = "Timeout Exception";
            }
            try
            {
                resultTXT.Text = serialPort1.ReadLine();
            }
            catch (TimeoutException)
            {
                resultTXT.Text = "Timeout Exception";
            }
        }

        private void cBoxComPort_DropDown(object sender, EventArgs e)
        {
            scanPort();
            //ListComPort();
        }
        private void ClosePort()
        {
            if (serialPort1.IsOpen)
            {
                serialPort1.Close();
                progressBar1.Value = 0;
            }
        }
        private void scanPort()
        {
            ports = SerialPort.GetPortNames();
            cBoxComPort.Items.Clear();
            cBoxComPort.Items.AddRange(ports);
            //cBoxComPort.SelectedIndex = 0;
        }
        private void sendComendToPort(string commend)
        {
            //string portText = cBoxComPort.SelectedValue.ToString();

            //if (portText == "Null")
            //{
            //    MessageBox.Show("לא נבחרה יציאה", "שגיאה");
            //    return;
            //}
            try
            {

                progressBar1.Value = 0;
                serialPort1.PortName = cBoxComPort.Text;
                serialPort1.BaudRate = 115200;
                serialPort1.ReadTimeout = 1500;
                serialPort1.WriteTimeout = 1500;
                progressBar1.Value = 50;
                ClosePort();
                serialPort1.Open();
                serialPort1.WriteLine(commend); //dl mode
                resultTXT.Text = serialPort1.ReadExisting();

                progressBar1.Value = 100;


            }
            catch (Exception err)
            {
                MessageBox.Show(err.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            scanPort();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            ClosePort();
            sendComendToPort("AT+SERIALNO=1,0");
            readruslt();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            ClosePort();
            sendComendToPort("AT+IMEINUM");
            readruslt();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            ClosePort();
            sendComendToPort("AT+SWVER");
            readruslt();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            ClosePort();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            ClosePort();
            sendComendToPort("AT+FUS?");
            readruslt();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            ClosePort();
            DialogResult dialogResult = MessageBox.Show("האם אתה בטוח שאתה רוצה לאפס את המכשיר?", "אזהרת איפוס", MessageBoxButtons.YesNo);
            if (dialogResult == DialogResult.Yes)
            {
                sendComendToPort("AT+FACTORST=0,0");
                readruslt();
            }
            else if (dialogResult == DialogResult.No)
            {
                //do something else
            }
            
        }
    }
}

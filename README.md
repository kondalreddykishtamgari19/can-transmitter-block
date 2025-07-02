🚗 CAN Transmitter Block Using CRC

🔧 Project Overview
This module simulates a Controller Area Network (CAN) Transmitter with Cyclic Redundancy Check (CRC) implementation to ensure data integrity during transmission. CAN is widely used in automotive and industrial systems for robust communication between microcontrollers and devices.

🎯 Objective

To design a CAN Transmitter Block that:

Accepts input data

Calculates a CRC checksum

Appends it to the message

Transmits the full CAN frame

💡 Key Features

Bit-level Transmission

CRC Generator Implementation (as per CAN standards)

CAN Frame Format:

Start of Frame

Identifier

Control Field

Data Field

CRC Field

ACK Slot

End of Frame

Error Detection

The receiver can verify CRC and detect corrupted frames.

🛠️ How It Works

Input Data: User provides an 8-bit data payload.

Frame Construction: The system constructs a CAN frame.

CRC Generation: The transmitter computes a CRC (usually 15-bit in standard CAN) using a predefined polynomial.

Transmission: The full frame (data + CRC) is sent bit-by-bit.

Receiver End (optional): Verifies CRC to ensure data integrity.

📐 CRC Polynomial
Commonly used polynomial for CRC-15 in CAN:

x^15 + x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + 1

Polynomial in binary: 1100010110011001

🧪 Test Cases

Valid Input: Correct data is transmitted with matching CRC.

Corrupted Bit: Receiver detects mismatch via CRC and raises error.

No Error: Frame received successfully.

📈 Applications

Automotive ECUs communication

Industrial machine controllers

Robotics and embedded system networks

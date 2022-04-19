# Embedded-Capstone: TerraBox

Senior Final Project for Embedded Systems Concentration

TerraBox Remote Controlled Terrarium

# Inspiration
Growing plants is a difficult and tedious hobby that requires constant attention, patience, resources; doing so indoors has proven to be a challenging task. Our Terrabox project is meant to directly address the precise climate, time, and resources, needed in growing a variety of plants in various climates. 

# What it does
Our project includes the following features:
1. Humidity control via a humidity sensor in conjunction with a humidifier.
2. Temperature control utilizes temperature sensors to identify the box temperature,
heating pads which heat up the box, and a fan which cools down the box.
3. LED lights which serve as the sunlight source for the box. The lights are used to
simulate daylight and natural heat from the sun.
4. Simulated rainfall via a sprinkler system to cool down terrarium wildlife and water
terrarium plants. Sprinkler system consists of a single mister connected to a
micro irrigation system.
5. Real time App control on the environment in the box
6. Real time environment status updates that can be viewed on the App

In order for the hardware to work in conjunction with the iOS App, the App is connected to a Google Firebase NoSQL database that is designed to communicated between the app and the Raspberry Pi. The Raspberry Pi processes the information from the database and sends it to the STM Discovery to drive the hardware. 



# How we built it

## Team Roles 

Throughout the development process of TerraBox, we broke down the development to focus around three key aspects of our product: development of a mobile application and integration of that app with a cloud database, the internet and inter-device communication of commands and telemetry data, and the construction and control of the necessary hardware components for the box itself. The six of us ended up splitting into three teams of two that each focused on each one of these three core aspects of the TerraBox development process. Clayden and Oscar worked on creating a mobile app and tying the app to work with a cloud database, Simon and Tristan worked to get all the hardware components working with the STM32 and much of the box built, and Bowen and Kahn worked to bridge the gap between the mobile app/cloud database and the embedded electronics by working out how the communication between all of these devices would work to have a fully cohesive and functioning system where commands on the app would be able to reach the box, and telemetry data from the box would be able to get sent back to the app. Though team members ended up focusing on one of these three development aspects, everyone reached beyond their primary section of work to help group members in other sections solve problems when needed. A more detailed description of individual roles is listed below.

Bowen: Set up the Raspberry Pi. Developed Python software on Raspberry Pi for the STM end and Firebase end. Built the real-time functions from Firebase to STM and sensors. Helped with TerraBox construction with the hardware team.

Clayden: Created Firebase project to act as the main database for iOS to microcontroller communication. Built back-end functionality for iOS app so that UI features would communicate with the database. Drafted UI designs for feature testing. Established user-authentication, and community posts pages for iOS app, and built in the corresponding database structure in Firebase.

Kahn: Develop python software on Raspberry Pi, build data transmission between STM32 to Raspberry Pi, and Raspberry Pi to Firebase cloud storage. Design and document the data format. Communicate between different teams to align the design.

Oscar: Designed IOS app prototype UI in Figma and implemented main control / status page that reads and writes values to firebase to control Terrabox functionality. Also
2
implemented live status indicators for reading and writing settings and measurements. Included features such as SVG rendering on climate selection and climate preset drop down menu.

Simon: Validated functionality of hardware components, designed how to best connect and control all the hardware components together, built the necessary components to get TerraBox working as if it were an actual product and built up the box itself.

Tristan: Developed all embedded software in C/C++ for the STM32F. Verified STM code functionality through testing and developed necessary connections between STM and components. Developed STM-to-Raspberry Pi connection via UART with Kahn and Bowen. Constructed Terrabox with Simon.

# System Requirements

## Functional Requirements

1.In order to operate the system, both raspberry pi, STM 32 and the plug form terrabox should be connected to power. 2 liters of water should be filled into the reservoir. 2.The system should be able to control the temperature and humidity in the set range, cycling the water in the box, and turning on the light in the set time.


## Firmware Requirements
1.The water cycling system is able to drain the plant from above and collect the water from bottom.

2.The heating system should be able to heat up the box to 37°C, and cool to room temperature.

3.The led light can be turned on or off.

## Software Requirements

1.The app will be able to add new users and store the login information for them.

2.The app can set time for light and sprinkler, temperature and humidity for the system. 3.The app can send data to firebase

4.The raspberry pi can receive and send data to STM32

5.The raspberry pi can receive and send data to Raspberry pi

6.The raspberry pi can control the flag for light and sprinkler based on the set time. 7.The STM is able to send and receive data from raspberry pi

8.The STM is able to maintain the target temperature using heating pad and fans. 9.The STM is able to maintain the target humidity using humidifier

10.The STM is able to turn on sprinklers and lights based on the flags.

## Thermal Requirements

The box will be able to maintain temperatures of 19-37°C in a room of 20°C. User Interface Requirements

6

The app is designed to operate on the IOS system, the user must have an IOS system client to use the app and control the system.

## Safety Requirements

The product consists of electricity and water, make sure not to flip or destroy any part or there will be a chance to cause electric shock.




# IoT--Turning-Home-Device-Lights
An iOS app designed to turn home devices/lights on and off using MQTT messaging protocol


# MQTT-in-iOS

Here I am demonstrating how MQTT works in ios. What is basic concepts of Internet of Thing(IoT) and its protocols. Etc.. 

## What is MQTT ? 

MQTT protocol is created based on publish and subscriber paradigm. A client that published the messages, called “Publisher” to 
the other client, called “Subscriber” who receive the message. 

MQTT is asynchronous where HTTP is synchronous so it does not block the client while it waits for the message. 

It does not require that client(subscriber) and  the publisher are connected at  the same time.

### MQTT publisher subscriber pattern: 

![mqtt](https://user-images.githubusercontent.com/10649284/36824970-05402fc2-1d2b-11e8-8d0e-e053be684342.png)

#### MQTT Broker:

Dispatching messages to MQTT clients (subscibers), so basically MQTT Broker receives the messages from Publisher and send it to
the subscriber.  When it dispatches the messages it uses the topic to filter the subscriber. The topic is a string and it is possible 
to combine topics creating topic levels.

#### Topic : 

A topic a virtual channel that connects publisher and subscriber. This topic is managed by MQTT broker. Through this virtual channel 
publishers are decoupled from subscribers, MQTT clients (publisher and subscriber) do not have to know each other to exchange the data. 

That’s why MQTT is highly scalable without a dependency between message producer (Publisher) and message consumer ( subscriber ).

![mqtt-2](https://user-images.githubusercontent.com/10649284/36825044-6e5c77fe-1d2b-11e8-8eca-59989b205f68.png)

## What is IoT (Internet of things) protocol ?

IoT promises to connect all the devices together and enable them to exchange the information. All the information is gathered and analysed to improve our life.

Generally speaking, Internet of things is an environment, or an ecosystem, where smart objects (including of course smartphones and so on) connect each other.
 

It affects across different sectors: 

(1). Transportation 
(2) healthcare 
(3) smart cities 
(4) agriculture 
(5) Retail 
(6) manufacturing  

### How these devices send and receive data ?

Well, we know HTTP protocol that makes possible to browse the net, opens web pages. But is this protocol still useful for IoT ?

Well, the answer is yes. But there are other protocol which are more efficient in low power devices. 

Below are the most important IoT protocols used IoT eco-system: 

#### (1) MQTT: (Message Queuing Telemetry Transport): 

it is machine to machine(M2M) oriented protocol. The architecture is very simple, based on client-server architecture. The client is generally a sensor which publishes (known as “Publisher”) the message/information to the server (“Broker”) which receives the information and dispatch it to the other client (known as “subscriber”). The underlying communication is based on “TCP” architecture.  

Generally speaking,  MQTT  protocol uses many to many paradigm and broker decouples publisher from subscriber and acts as a message router.  Eclipse has released open source implementation of MQTT called Mosquitto.

#### (2) COAP:  Constrained application protocol: 
This is a web transfer protocol, very much similar to HTTP protocol. It uses document transfer paradigm. 

### (3) Rest:  Representational state transfer protocol:  
It uses HTTP based protocol.


## How to use MQTT protocol :

Mosquito is an way developed by Eclipse team. 

### (1) install mosquitto MQTT:  

    brew install mosquitto

### (2) start the MQTT server: 

    // do a link 
    ln -sfv /usr/local/opt/mosquitto/*.plist ~/Library/LaunchAgents

    // start it now
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mosquitto.plist

### (3) Open a new terminal and add a subscriber:

    mosquitto_sub -t topic/state

### (4) Open another window and add a publisher with same topic:

    mosquitto_pub -t topic/state -m "Hello World" 

The subscriber will get the update what is sending by Publisher.
<img width="1128" alt="mosquitto" src="https://user-images.githubusercontent.com/10649284/36942467-6ec85fa4-1f98-11e8-9a71-249fa75f1d44.png">


### How to use MQTT using CocoaMQTT framework: 


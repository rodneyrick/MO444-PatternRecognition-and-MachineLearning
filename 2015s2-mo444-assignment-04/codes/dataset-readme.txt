Associated tasks: classification
Number of examples: 2,980,765 
Number of attributes: 6
Missing attribute values: No 
Class distribution: {
        Walking -> 1,255,923 -> 42.1%, 
        Jogging -> 438,871 -> 14.7%, 
        Stairs -> 57,425 -> 1.9%,
        Sitting -> 663,706 -> 22.3%,
        Standing -> 288,873 -> 9.7%,
	LyingDown -> 275,967 -> 9.3% }

raw.txt follows this format:
[user],[activity],[timestamp],[x-acceleration],[y-accel],[z-accel];

This line is a representative example:
33,Jogging,49105962326000,-0.6946377,12.680544,0.50395286;

Sampling rate:
20Hz (1 sample every 50ms)

Fields:
*user
        nominal

*activity
        nominal, {
                Walking
                Jogging
                Sitting
                Standing
                Upstairs
                Downstairs }

*timestamp
        numeric, unix epoch time in milliseconds

*x-acceleration
        numeric, floating-point values between -20 .. 20
                The acceleration in the x direction as measured
                by the android phone's accelerometer in m/(s^2).
                The acceleration recorded includes gravitational
                acceleration toward the center of the Earth, so
                that when the phone is at rest on a flat surface
                the vertical axis will register +-10.

*y-accel
        numeric, see x-acceleration

*z-accel
        numeric, see x-acceleration
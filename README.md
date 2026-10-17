# ISIM Labs

Code and data from my Introduction to Simulation, Instruments & Measurement (ISIM) labs. Each lab builds a small instrument from sensors and circuits, then uses MATLAB to turn the measured voltages into physical quantities like angle, temperature, and mass.

Portfolio with photos, circuits, and write-ups: [add your Adobe Portfolio link here]

## Projects

| Lab | Project | What it does |
|---|---|---|
| [01](01-pendulum) | Simple Pendulum | A potentiometer works as an angle sensor. A calibration curve converts its voltage to angle, giving the swing of a damped pendulum over time. |
| [02](02-thermistor) | Thermistor Thermometer | A thermistor in a voltage divider measures water temperature. The script converts voltage to resistance to temperature and compares how fast hot water cools with and without ice water. |
| [03](03-strain-gauge) | Strain Gauge Scale | A strain gauge on an aluminum beam, a Wheatstone bridge, and an instrumentation amplifier make a scale. A calibration curve converts voltage to mass, and the analysis works out how small the gauge's resistance change is. |

## Common approach
Every lab follows the same pipeline:
1. A **sensor** (transducer) turns a physical quantity into a change in resistance.
2. A **circuit** (voltage divider, Wheatstone bridge, amplifier) turns that into a voltage the oscilloscope can record.
3. A **calibration or transfer function** converts voltage back into a physical value, using a fitted line or the sensor's equation.
4. **MATLAB** loads the exported oscilloscope data, applies the conversion, and plots the result.

## Repository layout
```
isim-labs/
├── README.md
├── 01-pendulum/
├── 02-thermistor/
└── 03-strain-gauge/
```
Each folder has its own README with the method, results, and files.

## How to run
Open a lab's folder, put the MATLAB script and its CSV data files in the same folder, open the script in MATLAB, and run it. Each folder's README lists the files it needs.

## Tools
MATLAB, oscilloscope with wave generator, breadboard circuits, AD623 instrumentation amplifier, LMC6484 op-amps.

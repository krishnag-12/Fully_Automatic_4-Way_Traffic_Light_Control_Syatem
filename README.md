# Traffic Light Controller

This repository contains a Verilog implementation of a Traffic Light Controller designed to manage traffic at a four-way intersection. The module ensures smooth traffic flow by assigning green, yellow, and red lights for vehicles traveling in the North, South, East, and West directions.

## Features
- **Fully Sequential Design**: The controller uses state transitions to manage the light states.
- **Traffic-Responsive**: Adjusts the traffic light states based on the presence of vehicles in each direction.
- **Configurable Timing**: The duration for green and yellow lights can be customized via parameters.
- **Testbench Included**: A comprehensive testbench validates the functionality of the controller.

---

## Files
- **`traffic_light_controller.v`**: Verilog module implementing the traffic light controller.
- **`traffic_light_controller_tb.v`**: Testbench for simulating and verifying the traffic light controller.

---

## How It Works

### State Definitions
The controller operates in 8 states:
1. **S0**: North Green
2. **S1**: North Yellow
3. **S2**: East Green
4. **S3**: East Yellow
5. **S4**: South Green
6. **S5**: South Yellow
7. **S6**: West Green
8. **S7**: West Yellow

### Timing Parameters
- **`GREEN_TIME`**: Duration (in clock cycles) for a green light.
- **`YELLOW_TIME`**: Duration (in clock cycles) for a yellow light.

### Traffic Detection
Inputs (`N`, `S`, `E`, `W`) indicate the presence of traffic in each direction. The controller uses this information to decide the next state.

### Outputs
- **`Rn`, `Yn`, `Gn`**: North signals (Red, Yellow, Green)
- **`Re`, `Ye`, `Ge`**: East signals
- **`Rs`, `Ys`, `Gs`**: South signals
- **`Rw`, `Yw`, `Gw`**: West signals

---

## Testbench
The provided testbench (`traffic_light_controller_tb.v`) simulates the following scenarios:
1. Traffic only in the North direction.
2. Traffic only in the East direction.
3. Traffic only in the South direction.
4. Traffic only in the West direction.

### Running the Simulation
1. Instantiate the module under test (`traffic_light_controller`).
2. Apply the clock signal with a period of 10ns (100 MHz).
3. Simulate traffic in different directions using the respective input signals.
4. Observe the traffic light transitions and validate against expected behavior.

### Sample Output
The testbench uses `$monitor` to display the state of inputs and outputs during the simulation.

### Example:
Time Reset=0 | N=1, E=0, S=0, W=0 | Rn=0 Yn=0 Gn=1 | Re=1 Ye=0 Ge=0 | Rs=1 Ys=0 Gs=0 | Rw=1 Yw=0 Gw=0

---

## Customization
Modify the GREEN_TIME and YELLOW_TIME parameters in traffic_light_controller.v to adjust the duration of green and yellow lights based on your requirements.

## Contributing
Contributions are welcome! Please fork the repository and create a pull request for any enhancements or bug fixes.

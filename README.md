# sensei_garages

A garage system for the [ox_core](https://github.com/overextended/ox_core) framework using [ox_lib](https://github.com/overextended/ox_lib)

## 📋 To-do

- Seperate sea, air and land garages using vehicle class
- Implement group-owned vehicles (group garages already implemented)
- Add police impounding (ox_police)

## ✨ Features

- 3 configured garages. (with the hope that you will PR more 😁)

### Retrieving vehicles

- Vehicles spawn on pre-defined parking spots
- Built using ox_lib's context menu
- Vehicle images from FiveM docs
- Vehicle metadata (doors and seats)

### Storing vehicles

- Vehicle is stopped automatically
- Damage and vehicle health stored automatically

### Secure

- Server-side validation and permission checks

### Performant

- Uses ox_lib cache and zones
- Runs at 0.00ms, with 0.00% usage while not interacting

## 📦 Dependencies

- [ox_core](https://github.com/overextended/ox_core) (No other frameworks will be supported)
- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)

# SCONE build guide for dummies 

SCONE is a Monte Carlo radiation transport modelling/development tool. 
It is being developed and maintained by the nuclear energy research group of Cambridge University. 
SCONE is open source and the public repository is hosted [here](https://bitbucket.org/Mikolaj_Adam_Kowalski/scone/src/develop/). 

The official installation guide can be found [here](https://scone.readthedocs.io/en/latest/Installation.html). 
This "for dummies" guide is intended to make  the build process a bit easier for novice users/deveopers. 

This guide contains:

1. Things that you need as prerequisites. 
2. How to download/clone the source code from the publicly hosted repository.
3. Configure the build process. 
4. Compile the source code into an executable binary. 
5. Run tests to make sure the code compiled correctly.
6. Create a symbolic link.
7. Download ACE cross-section tables and configure an "entry" file to be used with SCONE.
8. Write a sample input file and run it.

## Prerequisites

### OS
This guide is specifiacally prepared for Ubuntu/WSL. Ubuntu based distros (e.g., Lubuntu, Pop OS) should work as well. 

If you have a dedicated Ubuntu machile, thats great!

If you are on a Windows machine, Windows Subsystem for Linux or WSL might just be the best option for you. It is a compatibility layer that lets you run a complete Ubuntu terminal environment (or any Linux binary executables) natively on Windows. Go to Microsoft Store and write "Ubuntu" on the serach bar. Insatalltion should be trivial. Ensure that the Virtual Machine Platform and Windows Subsystem for Linux features are selected in Windows Features. SCONE runs on WSL perfectly fine. 

### Required repositories
Before attempting SCONE compilation, the following software packages should be presnt on the machine, 

1. A meta-package named “build-essential” that includes the GNU compiler collection, GNU debugger, and other development libraries and tools required for compiling software. 
2. Fortran (must be version 7)
3. CMake (version 3.10+)

Additionally,

4. Git
5. OpenMP
6. LAPACK and BLAS
7. pFUnit (optional)

Open a terminal (or in Windows, a Ubuntu terminal environment) and issue the following commands,

```sh
$ sudo apt update
$ sudo apt install build-essential
$ sudo apt install gfortran
$ sudo apt install cmake
```
When you try to install gfortran with apt, it installs the latest available version (e.g., 9.x.x or 10.x.x). You can check the version with ``gfortran --verison``. However SCONE requires gfortran version 7.x.x, otherwise it will not compile! 

So you need to downgrade it. 

> It is wortwhile to cover some basics here so you can appreciate what is happening next. When you type in ``gfortran``, it is actually a symbolic link located at ``/usr/bin/gfortran``. This location (along with other locations) is stored in an environment variable called ``PATH``. To view your ``PATH`` variable, type ``echo $PATH``. To view all the environment variable for the current user, type ``env``.    

>Right now ``/usr/bin/gfortran`` points to, for example, 
``/usr/bin/x86_64-linux-gnu-gfortran-9`` which is the 9.x.x binary.
Whereas you need to make ``/usr/bin/gfortran`` to point to a 7.x.x
binary.

The easiest way to install gfortran 7.x.x is, obviously, using the apt utility. If you do a repository search using ``apt-cache search gfortran``, there is gfortran-7 on the list! Istall this repository by typing, 

```sh
$ sudo apt isntall gfortran-7
```
Now there will be a new symlink ``/usr/bin/gfortran-7`` pointing to
``/usr/bin/x86_64-linux-gnu-gfortran-7``. This ``x86_64-linux-gnu-gfortran-7`` is the 
compiler you need to compile SCONE. Now, you would want ``gfortran`` to point to this compiler. Issue the following commands, 

```sh
$ sudo rm /usr/bin/gfortran
$ sudo ln -s /usr/bin/x86_64-linux-gnu-gfortran-7 /usr/bin/gfortran
```

Now, you can can check whether the association was correctly done by typing ``gfortran --version``. The reported version should now be 7.x.x.

Move on to installing the remaining repositories, 

```sh
$ sudo apt install git
$ sudo apt install libomp-dev libomp5
$ sudo apt install libblas-dev liblapack-dev
```

Installtion of pFUnit is omitted. 

## Build SCONE 

### Clone the SCONE repository

To use SCONE, first move to yout home directory ``~`` use clone the repository,

```sh
$ cd ~
$ git clone --branch develop https://bitbucket.org/Mikolaj_Adam_Kowalski/scone SCONE
$ cd SCONE
$ rm -rf .git/
```
This will clone only the develop branch of the project. 

### Configrue and Compile SCONE
SCONE uses CMake to control the compilation process. To avoid clutter, you are going to create a new folder inside the SCONE directory and put the generated configuration and build files inside it. Issue the following commands,  

```sh
$ mkdir Build
$ cd Build 
$ sudo cmake .. -DBUILD_TESTS=OFF
```
At this point the makefiles are generated. Now compile SCONE using the following command, 

```sh
$ sudo make
````
With the compilation done, the executable binary "scone.out" should be located inside the same Build direc

### Create a symlink

The following lets SCONE be invoked from anywhere (creating a symlink),

```sh
$ sudo ln -s ~/scone/Build/scone.out /usr/bin/scone
```

Now you can run SCONE from anywhere you want by just typing ``scone`` in the terminal. 


## Obtaining ACE tables and configuring the entry file 

download ACE tables from here NNDC/BNL ENDF 7.1
create SCONE's own xsdir (like MCNP) file using this script/code <- entry file

## Preparing your first input file and running SCONE

TBD

SCONE can be run like this
```sh
--plot               Executes geometry plotting specified by a viz dict in the input file
--omp <int>          Number of OpenMP threads in a parallel calculation
```



## Maintainers

[@saad589](https://github.com/saad589).

## Contributing

Feel free to dive in! [Open an issue](https://github.com/saad589/matcom/issues/new) or submit PRs.

MATCOM follows the [Contributor Covenant](http://contributor-covenant.org/version/1/3/0/) Code of Conduct.


## License

[GPL](LICENSE) © Saad Islam

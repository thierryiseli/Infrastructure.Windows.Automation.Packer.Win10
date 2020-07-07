# Infrastructure.Windows.Automation.Packer

Windows 10 packer for creating a *.box for vagrant.

## Getting Started

### Prerequisites

| Program | Version | Link | Info |
|-------------|-------------|-----|--|
| Windows | 10 | https://www.microsoft.com/de-de/software-download/windows10 | N/A |

### Preparing

Clone or download the current repository to your preferred location.
Download Windows ISO-File with following link: https://docs.google.com/uc?export=download&id=15iR0Ru_XThYBzbMW9QXzl1Sk8yLd9wWU and move it to the location of the cloned or copied repository.

### Installing

Install packer with Chocolatey on Command Prompt or PowerShell:

```
cinst packer -y
```
If you have not installed chocolatey, please refer to https://chocolatey.org/install. 

## Running (on Windows)

Open Command Prompt as administrator and switch to the location of the cloned or copied repository:

```
cd yourLocalRepositoryPath
```

Run following command to generate the *.box-File for vagrant:

```
packer build windows10.json
```

Wait until command has finished. This may take a few minutes. After that a windows10.box file should be created in the current directory.

## Authors

- [Thierry Iseli](https://github.com/thierryiseli) - *Inital work*

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Built With

- [Packer](https://www.packer.io/)

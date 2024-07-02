# Midas Online Data Base (ODB) Configuration

## ODB basics

Below are some basic usage examples of midas' ODB

### Accessing the ODB

#### Command line interface

You can edit the ODB via command line without needing a midas webserver running.
```
$MIDASSYS/bin/odbedit
```
Then you can navigate through the ODB as you would with linux directory commands. From here, you can type "help" or view the [odbedit command list](https://daq00.triumf.ca/MidasWiki/index.php/Odbedit_command_list) for a list of commands.

#### Via Midas Webpage

You can start a midas webpage by running `mhttpd` (or `mhttpd6`)
```
$MIDASSYS/bin/mhttpd
```
Then view the ODB by clicking the **ODB** button on the left sidebar

### General ODB configuration examples

#### Toggle logger data writing

#### Change webpage port

---

##
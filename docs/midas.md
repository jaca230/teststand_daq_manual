# Some Midas Information and Tips
TRIUMF has a great [Midas Wiki](https://daq00.triumf.ca/MidasWiki/index.php/Main_Page) page. For general midas information, this is a good place to start. Below, there are some specific tips about midas that are helpful when using the g-2 modified DAQ.

## Data Storage location
By default midas files (.mid) and compressed midas files (.mid.lz4) will be stored in the same directory that the file `$MIDAS_EXPTAB` is located (usually the "online" directory). This can be can be [changed to a different directory in the Logger's ODB settings](odb_config.md#change-logger-data-writing-directory).

---

## Midas Files to ROOT Files (unpacker)

See the [unpacker software page](software_add_ons.md#midas-event-unpacker).

Once that is installed, you can convert midas files to root files using the command:
```
./pioneer_unpacker MIDAS_FILE.mid.lz4 0 detector_mapping.json
```

---

## Recovering from a Corrupted ODB

There should be a folder in `$GM2DAQ_DIR/restore_corrupted_ODB` or `$GM2DAQ_DIR/scripts/restore_corrupted_ODB` (if not, you may need to look in the default branch). Navigate to this directory and run one of the following two scripts:

Fun version:
```
./midas_restore.sh
```

Less fun version:
```
./delete_and_restore_odb.sh
```

Both scripts have the exact same functionality; they effectively stop all running screens (midas related or not), delete all ODB data, and load a backup file. However the first script has some fun surprises for the user's pleasure. If this script doesn't work, you can follow the steps in ["Fixing a persistently corrupted ODB by hand"](midas.md#fixing-a-persistently-corrupted-odb-by-hand).

---

## Fixing a corrupted ODB by hand

These instructions are adapted from the [midas wiki's page on recovering from a corrupted ODB](https://daq00.triumf.ca/MidasWiki/index.php/FAQ#How_to_recover_from_a_corrupted_ODB). For most cases, you can just "nuke" the ODB and then load an ODB save file from a previous run. **Make sure you have an ODB backup file** to load (ex. run001234.json).

1 **Stop midas screens by hand**

```
screen -ls
```

Note all midas screens running and close them, for instance:
```
screen -X -S mhttpd quit
screen -X -S mlogger quit
screen -X -S mserver quit
```

Verify they are all close with
```
screen -ls
```
once again.

2 **Reset the ODB to midas default**

```
$MIDASSYS/bin/odbinit -s {ODB memory} --cleanup
```
Then follow the text prompts.

For example:
```
$MIDASSYS/bin/odbinit -s 1024MB --cleanup
```

3 **Load old ODB** 

```
$MIDASSYS/bin/odbedit -c "load online/run001234.json"'
```

Replace the path `online/run001234.json` with the location of an actual ODB backup that you know was working.

### Fixing a persistently corrupted ODB by hand

If nothing else works to fix a corrupted ODB, these steps act as a "brute force" reset. The steps below are actually the same steps done in the scripts mentioned in [Recovering from a Corrupted ODB](midas.md#recovering-from-a-corrupted-odb). **Make sure you have an ODB backup file** to load (ex. run001234.json).

1 **Forcefully close out of all screens on the machine**

```
killall mserver mevb mlogger mhttpd mhttpd6 frontend mtransition > /dev/null 2>&1
killall -9 mserver mevb mlogger mhttpd mhttpd6 frontend mtransition > /dev/null 2>&1
$MIDASSYS/progs/mcleanup > /dev/null 2>&1
screen -wipe > /dev/null 2>&1
killall screen > /dev/null 2>&1
screen -wipe > /dev/null 2>&1
```

2 **Delete Shared Memory Files**

```
export EXP=$MIDAS_EXPT_NAME
export EXP_PATH=$(dirname "$MIDAS_EXPTAB")
rm -rf /dev/shm/*_${EXP}_ODB_* > /dev/null 2>&1
rm -rf /dev/shm/*_${EXP}_ODB_* > /dev/null 2>&1
rm -rf /dev/shm/*_${EXP}_ODB_* > /dev/null 2>&1
rm -rf $EXP_PATH/.*.SHM > /dev/null 2>&1
rm -rf $EXP_PATH/.*.TXT > /dev/null 2>&1
```

3 **Create new ODB and load old ODB file**

```
export JsonPath=online/run001234.json
export run_number=1000
$MIDASSYS/bin/odbedit -e $EXP -s 40000000 -c "ls" > /dev/null 2>&1
$MIDASSYS/bin/odbedit -e $EXP -c "load $JsonPath" > /dev/null 2>&1
$MIDASSYS/bin/odbedit -e $EXP -c "set \"/Runinfo/Run number\" $run_number" > /dev/null 2>&1
```
where `JsonPath` and `run_number` are replaced with the paths to an ODB backup and the desired starting run number respectively. **You should set the run number to a value higher than your last run number as to not overwrite and data**.

4 **Reload midas webpage**
```
$MIDASSYS/bin/mhttpd
```

Verify everything looks as expected on the webpage. Then you can reload frontends and any other screens that were running beforehand.

---

## Loading an ODB save

You can use the ODB to load an old ODB save file. 

```
$MIDASSYS/bin/odbedit
```
Then in the command line interface:
```
load online/run001234.json
```

Alternatively, you can "stuff" commands into odbedit from command line:

```
$MIDASSYS/bin/odbedit -c "load online/run001234.json"'
```

where `online/run001234.json` should be replaced with a path to a valid ODB save file.

In my experience, this only adds settings (or changes settings back). It will not remove settings. For example if path `/Equipment/Test` exists in the current ODB but not the save, it will still exist after the save is loaded.

You can also load only specific parts of an ODB by navigating to the appropriate path. For example:

```
$MIDASSYS/bin/odbedit
```

then in the command line interface

```
cd Equipment
load online/run001234.json
```

Now only the settings under `/Equipment` will be altered in your ODB by loading the save.

---

## Changing the ODB size
See the [midas wiki page for changing ODB size](https://daq00.triumf.ca/MidasWiki/index.php/FAQ#Increasing_Number_of_Hot-links).

1 **Save Current ODB if needed**

```
$MIDASSYS/bin/odbedit -c "save current_odb.odb"
```

2 **Stop midas screens by hand**

```
screen -ls
```

Note all midas screens running and close them, for instance:
```
screen -X -S mhttpd quit
screen -X -S mlogger quit
screen -X -S mserver quit
```

Verify they are all close with
```
screen -ls
```
once again.

3 **Delete Shared Memory Files**

```
export EXP=$MIDAS_EXPT_NAME
export EXP_PATH=$(dirname "$MIDAS_EXPTAB")
rm -rf /dev/shm/*_${EXP}_ODB_* > /dev/null 2>&1
rm -rf /dev/shm/*_${EXP}_ODB_* > /dev/null 2>&1
rm -rf /dev/shm/*_${EXP}_ODB_* > /dev/null 2>&1
rm -rf $EXP_PATH/.*.SHM > /dev/null 2>&1
rm -rf $EXP_PATH/.*.TXT > /dev/null 2>&1
```


4 **Edit file $MIDASSYS/include/midas.h**

Find:
```
#define MAX_OPEN_RECORDS       256 
```
Change this to:
```
#define MAX_OPEN_RECORDS       65536
```

**Note:** This can be changed to a larger number (up to some limit I don't know)

5 **Edit file $MIDASSYS/src/odb.cxx**

Find:
```
assert(sizeof(DATABASE_CLIENT) == 2112);
assert(sizeof(DATABASE_HEADER) == 135232);
```
Change to:
```
assert(sizeof(DATABASE_CLIENT) == 524352);
assert(sizeof(DATABASE_HEADER) == 33558592);
```

**Note:** These numbers follow a formula on the wiki, they are related to the variable MAX_OPEN_RECORDS
```
DATABASE_CLIENT = 64 + 8*MAX_OPEN_RECORDS 
DATABASE_HEADER = 64 + 64*DATABASE_CLIENT
```

6 **Remake MIDAS**

Follow the wiki's [quickstart linux guide](https://daq00.triumf.ca/MidasWiki/index.php/Quickstart_Linux#MIDAS_Package_Installation).
```
cd midas
mkdir build
cd build
cmake ..
make install
```

7 **Create new ODB**
```
$MIDASSYS/bin/odbinit -s 1024MB --cleanup
```

**Note:** I had trouble unless the number specified by -s was the different than the previous ODB. From there it will prompt you to delete a file. I think this file contains information about the maximum number of hotlinks and must be deleted every time you want to increase the number of hotlinks

8 **Load old settings (if saved)**
```
$MIDASSYS/bin/odbedit -c "load current_odb.odb"
```

9 **Rebuild all programs with midas dependencies**

Because we rebuilt midas, this also means we have to rebuild the frontends. See the "Make Frontends" section of the [frontend manual installation guide](installing_and_building.md#manual-installation-guide). Any other software you have built against this version of midas must also be rebuilt (that includes the [publisher](software_add_ons.md#midas-event-publisher), for example).

---

## Adding Program Startup Scripts

After any frontend is run, it will appear in the ODB under `/Programs/{Frontend Name}`. Here there are some settings for the program. The I use for starting frontends are

**Required**:

Set `/Programs/{Frontend Name}/Required` to `yes` to pin the program onto the `Programs` page accessible from the left sidebar. In other words, when the frontend is not running, it will not dissapear from the programs page.

**Start Command**:

Change `/Programs/{Frontend Name}/Start Command` to a command that you when to be run when hitting the `Start {Frontend Name}` button on the Programs page. This is allows the user to start a frontend in the background from the midas webpage; i.e. you can avoid starting frontends from command line.



---


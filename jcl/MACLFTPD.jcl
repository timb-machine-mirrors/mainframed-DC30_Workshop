//MACLFTPD JOB (TSO),
//             'Install MACLIB',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//*
//* Install SYS2.MACLIBS and the FTPD Server
//*
//MVPINST EXEC MVP,INSTALL='MACLIB -D' 
//MVPINST EXEC MVP,INSTALL='FTPD -D' 
//*
//* Give all users access to FTPD
//*
//ADDRAKFP EXEC PGM=SORT,REGION=512K,PARM='MSG=AP'
//STEPLIB  DD   DSN=SYSC.LINKLIB,DISP=SHR
//SYSOUT   DD   SYSOUT=A
//SYSPRINT DD   SYSOUT=A
//SORTLIB  DD   DSNAME=SYSC.SORTLIB,DISP=SHR
//SORTOUT  DD   DSN=SYS1.SECURE.CNTL(PROFILES),DISP=SHR
//SORTWK01 DD   UNIT=2314,SPACE=(CYL,(5,5)),VOL=SER=SORTW1
//SORTWK02 DD   UNIT=2314,SPACE=(CYL,(5,5)),VOL=SER=SORTW2
//SORTWK03 DD   UNIT=2314,SPACE=(CYL,(5,5)),VOL=SER=SORTW3
//SORTWK04 DD   UNIT=2314,SPACE=(CYL,(5,5)),VOL=SER=SORTW5
//SORTWK05 DD   UNIT=2314,SPACE=(CYL,(5,5)),VOL=SER=SORTW6
//SYSIN  DD     *
 SORT FIELDS=(1,80,CH,A)
 RECORD TYPE=F,LENGTH=(80)
 END
/*
//SORTIN DD DSN=SYS1.SECURE.CNTL(PROFILES),DISP=SHR
//       DD DATA,DLM=@@
FACILITYFTPAUTH                                     USERS   READ
DATASET DEFCON.*                                            READ
DATASET WHITE.RABBIT                                        NONE
@@
//*
//* Update the RAKF database
//*
//RAKFUPDT EXEC RAKFPROF
//*
//* Create custom FTPD procedure
//*
//FTPDPROC EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.PROCLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=FTPDDC30
//FTPDDC30 PROC SRVPORT='2121',AUTHUSR='IBMUSER',SYSUDMP='A'
//********************************************************************
//*                                                                   
//* MVS3.8J RAKF ENABLED FTP SERVER PROC WITH CUSTOM ARGUMENTS        
//* TO USE: IN HERCULES CONSOLE ISSUE                                 
//*    /S FTPDPARM,SRVPORT=54321,SRVIP=10.10.10.10                    
//*                                                                   
//********************************************************************
//FTPD   EXEC PGM=FTPDXCTL,TIME=1440,REGION=4096K,
// PARM='SRVPORT=&SRVPORT DD=AAINTRDR AUTHUSR=&AUTHUSR'
//AAINTRDR DD SYSOUT=(A,INTRDR),DCB=(RECFM=FB,LRECL=80,BLKSIZE=80)
//STDOUT   DD SYSOUT=*
//SYSUDUMP DD SYSOUT=&SYSUDMP
@@

# Name
#    checkout.py
#
# Purpose
#    Fetch all project dependencies requested by input .def file.
#
# Revision Dates
#    22-Mar-2020 (SSB) [] Initial
#    22-Mar-2020 (BSE) [] Parse comments in .dep files
#                         and fix directory handling

import os
import sys
import json
import zipfile

try:
    import gdown
except:
    os.system('pip install gdown')
    import gdown

# Define global variables
gdrive_def_link = 'https://drive.google.com/uc?id='
libs_dir_rel    = '../libs/'

def dump_help():
    print('Usage example: checkout.py /etc/projects/jtag/jtag.dep')
    sys.exit()

def validate_args():
    if ( len(sys.argv) < 2 ):
        print('Error: Provide .dep input file.')
        dump_help()
    elif ( len(sys.argv) > 2 ):
        print('Error: Too many command line arguments.')
        dump_help()
    else:
        if ( False == sys.argv[1].endswith('.dep')):
            print('Error: Provide .dep file.')
            dump_help()

def main():
    validate_args()

    file_dir     = os.path.dirname( __file__ )
    libs_dir     = os.path.join( file_dir, libs_dir_rel )
    file_dir_abs = os.path.abspath( file_dir )
    libs_dir_abs = os.path.abspath( libs_dir )

    if ( False == os.path.exists( libs_dir_abs )):
        os.system( 'mkdir ' + libs_dir_abs )

    try:
        jfile = open(os.path.join( file_dir_abs,'dependencies.json'), 'r')
        jdata = json.load(jfile)
        jfile.close()
    except:
        print('Error: File dependencies.json not accessible.')
        sys.exit()

    try:
        ifile = open( sys.argv[1], 'r' )
        idata = ifile.readlines()
        idata = [ x.partition("#")[0].strip() for x in idata ]
        idata = filter(None, idata)
        ifile.close()
    except:
        print('Error: File ' + sys.argv[1] + ' not accessible.')
        dump_help()

    for lib in idata:
        dep = next(( dep for dep in jdata if lib == dep["name"] ), None )
        if ( None != dep ):
            if ( 'gdrive' == dep['location'] ):
                destination_folder = os.path.join( libs_dir_abs, lib )
                destination_file   = destination_folder + '.zip'

                if ( False == os.path.exists( destination_folder )):
                    gdown.download( gdrive_def_link + dep['link']
                                  , destination_file
                                  , quiet = False
                                  )
                    print('Extracting files...')
                    with zipfile.ZipFile( destination_file, 'r' ) as zf:
                        zf.extractall( libs_dir_abs )
                    print('Removing temporary files...')
                    os.system('rm -rf ' + destination_file)
                else:
                    print('Dependency ' + lib + ' already exists.')
        else:
            print('Dependency ' + lib  + ' not supported! Check the .dep file!')

if __name__ == "__main__" :
    main()

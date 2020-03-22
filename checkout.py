# Name
#    checkout.py
#
# Purpose
#    Fetch all project dependencies requsted by input .def file.
#
# Revision Dates
#    22-Mar-2020 (SSB) [] Initial

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
libs_dir        = '../!libs/'
gdrive_def_link = 'https://drive.google.com/uc?id='

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

    try:
        jfile = open('dependencies.json', 'r')
        jdata = json.load(jfile)
        jfile.close()
    except:
        print('Error: File dependendies.json not accessible.')
        sys.exit()

    try:
        ifile = open( sys.argv[1], 'r' )
        idata = ifile.readlines()
        idata = [ x.strip() for x in idata ]
        ifile.close()
    except:
        print('Error: File ' + sys.argv[1] + ' not accessible.')
        dump_help()

    for lib in idata:
        dep = next(( dep for dep in jdata if lib == dep["name"] ), False )
        if ( False != dep ):
            if ( 'gdrive' == dep['location'] ):
                if ( False == os.path.exists( libs_dir + lib )):
                    gdown.download( gdrive_def_link + dep['link']
                                  , libs_dir + lib + '.zip'
                                  , quiet = False
                                  )
                    print('Extracting files...')
                    with zipfile.ZipFile( libs_dir + lib + '.zip'
                                        , 'r' ) as zf:
                        zf.extractall( libs_dir )
                    print('Removing temporary files...')
                    os.system('rm -rf ' + libs_dir + lib + '.zip')
                else:
                    print('Dependency ' + lib + ' already exists.')
        else :
            print('Dependency ' + lib  + ' not supported! Check the .dep file!')

if __name__ == "__main__" :
    main()

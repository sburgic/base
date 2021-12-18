## Name
##   oshelpers.mk
##
## Purpose
##   Host OS build definitions and functions
##
## Revision
##    28-Mar-2020 (SSB) [] Initial
##    19-Dec-2020 (SSB) [] Introduce CP tool
##    24-Jan-2021 (SSB) [] Fix typo in toupper function
##    19-Nov-2021 (SSB) [] Add OS check
##

ifeq ($(OS),Windows_NT)
    HOST_OS := windows
else
    uname_s := $(shell uname -s)

    ifeq ($(uname_s),Linux)
        HOST_OS := linux
    endif
endif

ifeq ($(HOST_OS),)
    $(error Unsupported host OS!)
endif

MD := mkdir -p
RM := rm -rf
CP := cp -u

# Convert lowercase to uppercase
# We are using custom function to support all platforms
toupper = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$1))))))))))))))))))))))))))

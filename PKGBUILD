pkgname=efistub-wrapper
pkgrel=1
pkgver=0
pkgdesc='Passes kernel-commandline to the kernel if the UEFI does not support it e.g most DELL laptops; NO use of Systemd-boot'
arch=('x86_64')
source=("${pkgname}::git+https://github.com/Kakashiiiiy/EFISTUB.git")
license=('None')
url='https://github.com/Kakashiiiiy/EFISTUB'
depends=('efibootmgr')
SRCDEST="/tmp"

sha512sums=('SKIP')
provides=("efistub-wrapper")
conflicts=("efistub-wrapper")
options=(debug !strip)



prepare(){
	cd ${srcdir}/${pkgname}
	CMDLINE=$(cat /proc/cmdline) # <- If you do not want /proc/cmdline change it here
	source configure
}

build(){
		cd ${srcdir}/${pkgname}
		printf "If you don't trust my precompiled binaries you can install gnu-efi-libs and adjust LIB and EFILIB (MAKEFILE) with you local dirs\n\n"
		make
}

package(){
		cd ${srcdir}/${pkgname}
		make DESTDIR="${pkgdir}" install
		printf "RUN: ${RED}efibootmgr -c -d /dev/sd* -p *PARTITIONNUMBER* -l 'efistub.efi' -L 'Arch-EFI'\033[0m to complete the installation\n\n" 
		printf "assuming you ESP is located under /boot otherwise move efistub.efi to the root of your ESP\n"
}

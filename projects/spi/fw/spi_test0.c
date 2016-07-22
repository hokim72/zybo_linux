#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

#define SRR		(0x40/4)

#define SPICR	(0x60/4)
#define MTI		8
#define MASTER	2
#define SPE		1

#define SPISR	(0x64/4)
#define TXF		3

#define SPIDTR	(0x64/4)
#define SPISSR	(0x70/4)

void set_bit(uint32_t *reg, unsigned int pin, unsigned int value)
{
	if (value) {
		*reg |= 1<<pin;
	} else {
		*reg &= ~(1<<pin);
	}
}

int main()
{
	int fd;
	uint32_t *spi;
	char *name = "/dev/mem";

	if ((fd = open(name, O_RDWR)) < 0)
	{
		perror("open");
		return 1;
	}

	spi = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);

	spi[SRR] = 0x0000000A; // Reset
	set_bit(&spi[SPICR], MTI, 0);
	set_bit(&spi[SPICR], MASTER, 1);
	set_bit(&spi[SPICR], SPE, 1);

	printf("SPICR = 0x%X\n", spi[SPICR]);
	printf("SPISSR = 0x%X\n", spi[SPISSR]);


	uint8_t sendBuffer = {0xAA, 0x0F, 0xF0};
	while (1) {
		set_bit(&spi[SPISSR], 0, 0);
		for (int i=0; i<3; i++) {
		}
		set_bit(&spi[SPISSR], 0, 1);
		usleep(100);
	}

	munmap(spi, sysconf(_SC_PAGESIZE));
	close(fd);
	return 0;
}

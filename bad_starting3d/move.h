/* StonerView: An eccentric visual toy.
	Copyright 1998 by Andrew Plotkin (erkyrath@netcom.com)
	http://www.edoc.com/zarf/stonerview.html
	This program is distributed under the GPL.
	See main.c, the Copying document, or the above URL for details.
*/

#import "osc.h"

struct elem_t 
{
	float pos[3];
	float vervec[2];
	float col[3];
};

typedef int bool;

extern struct elem_t* elist;
extern int elistElts;

bool init_move(int numElts);
void move_increment();

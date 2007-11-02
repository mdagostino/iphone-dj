/* StonerView: An eccentric visual toy.
	Copyright 1998 by Andrew Plotkin (erkyrath@netcom.com)
	http://www.edoc.com/zarf/stonerview.html
	This program is distributed under the GPL.
	See main.c, the Copying document, or the above URL for details.
*/

#include "osc.h"
#include "move.h"

#include <math.h>
#include <stdlib.h>

/* The list of polygons. This is filled in by move_increment(), and rendered
	by perform_render(). */
struct elem_t *elist = 0;
int elistElts = 0;

/* The polygons are controlled by four parameters. Each is represented by
	an osc_t object, which is just something that returns a stream of numbers.
	(Originally the name stood for "oscillator", but it does ever so much more
	now... see osc.c.)
	Imagine a cylinder with a vertical axis (along the Z axis), stretching from
	Z=1 to Z=-1, and a radius of 1.
*/
static osc_t *theta = 0; /* Angle around the axis. This is expressed in
	hundredths of a degree, so it's actually 0 to 36000. */
static osc_t *rad = 0; /* Distance from the axis. This goes up to 1000,
	but we actually allow negative distances -- that just goes to the opposite
	side of the circle -- so the range is really -1000 to 1000. */
static osc_t *alti = 0; /* Height (Z position). This goes from -1000 to 1000. */
static osc_t *color = 0; /* Consider this to be an angle of a circle going around
	the color wheel. It's in tenths of a degree (consistency is all I ask) so it
	ranges from 0 to 3600. */

bool init_move(int numElts)
{
	elistElts = numElts;
//	elist = new elem_t[numElts];
	elist = (struct elem_t*) malloc(sizeof(struct elem_t) * numElts);
	
//	theta = new_osc_linear(
//		new_osc_velowrap(0, 36000, new_osc_multiplex(
//			new_osc_randphaser(300, 600),
//				new_osc_constant(25),
//				new_osc_constant(75),
//				new_osc_constant(50),
//				new_osc_constant(100))
//		),
//		
//		new_osc_multiplex(
//				new_osc_buffer(new_osc_randphaser(300, 600), elistElts),
//			new_osc_buffer(new_osc_wrap(0, 36000, 10), elistElts),
//			new_osc_buffer(new_osc_wrap(0, 36000, -8), elistElts),
//			new_osc_wrap(0, 36000, 4),
//			new_osc_buffer(new_osc_bounce(-2000, 2000, 20), elistElts)
//		)
//	);



	theta = new_osc_linear(
		new_osc_velowrap(0, 36000, new_osc_constant(25) ),
		new_osc_wrap(0, 36000, 4)
	);

//	rad = 
	rad = new_osc_buffer(new_osc_linear(new_osc_bounce(  400, 1000, 10), new_osc_constant(25)), elistElts);

//	rad = new_osc_buffer(new_osc_multiplex(
//			new_osc_randphaser(250, 500),
//		new_osc_bounce(-1000, 1000, 10),
//		new_osc_bounce(  200, 1000, -15),
//		new_osc_bounce(  400, 1000, 10),
//		new_osc_bounce(-1000, 1000, -20)), elistElts);
	
	alti = new_osc_linear(
		new_osc_constant(-1000),
		new_osc_constant(2000 / elistElts));

	color = new_osc_multiplex(
			new_osc_buffer(new_osc_randphaser(150, 300), elistElts),
		new_osc_wrap(0, 3600, 13),
		new_osc_wrap(0, 3600, 32),
		new_osc_wrap(0, 3600, 17),
		new_osc_wrap(0, 3600, 7));

	move_increment();

	return 1;
}

void final_move()
{
}

/* Set up the list of polygon data for rendering. */
void move_increment()
{
	int ix, val;
	float pt[2];
	float ptRad, ptTheta;
	
	for (ix=0; ix<elistElts; ix++) {
		struct elem_t *el = &elist[ix];
		
		/* Grab r and theta... */
		val = osc_get(theta, ix);
		ptTheta = val * (M_PI / 180.0) * 0.01;
		ptRad = (float)osc_get(rad, ix) * 0.001;
		/* And convert them to x,y coordinates. */
		pt[0] = ptRad * sinf(ptTheta);
		pt[1] = ptRad * cosf(ptTheta);
		
		/* Set x,y,z. */
		el->pos[0] = pt[0];
		el->pos[1] = pt[1];
		el->pos[2] = (float)osc_get(alti, ix) * 0.001;
		
		/* Set which way the square is rotated. This is fixed for now, although
			it would be trivial to make the squares spin as they revolve. */
		el->vervec[0] = 0.11;
		el->vervec[1] = 0.0;
		
		/* Grab the color, and convert it to RGB values. Technically, we're
			converting an HSV value to RGB, where S and V are always 1. */
		val = osc_get(color, ix);
		if (val < 1200) {
			el->col[0] = ((float)val / 1200.0);
			el->col[1] = 0;
			el->col[2] = (float)(1200 - val) / 1200.0;
		} 
		else if (val < 2400) {
			el->col[0] = (float)(2400 - val) / 1200.0;
			el->col[1] = ((float)(val - 1200) / 1200.0);
			el->col[2] = 0;
		}
		else {
			el->col[0] = 0;
			el->col[1] = (float)(3600 - val) / 1200.0;
			el->col[2] = ((float)(val - 2400) / 1200.0);
		}
	}
	
	osc_increment();
}


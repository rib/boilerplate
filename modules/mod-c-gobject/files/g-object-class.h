/*
 * vim: tabstop=8 shiftwidth=2 noexpandtab softtabstop=2 cinoptions=>2,{2,:0,t0,(0,W4
 *
 * <copyright_assignments>
 * Copyright (C) 2008  Robert Bragg
 * </copyright_assignments>
 *
 * <license>
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA  02110-1301, USA.
 * </license>
 *
 */

#ifndef MY_OBJECT_H
#define MY_OBJECT_H

#include <glib.h>
#include <glib-object.h>
#error "You need to include your parent class header"

G_BEGIN_DECLS

#define MY_OBJECT(obj)		  (G_TYPE_CHECK_INSTANCE_CAST ((obj), MY_TYPE_OBJECT, MyObject))
#define MY_TYPE_OBJECT		  (my_object_get_type())
#define MY_OBJECT_CLASS(klass)	  (G_TYPE_CHECK_CLASS_CAST ((klass), MY_TYPE_OBJECT, MyObjectClass))
#define MY_IS_OBJECT(obj)	  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), MY_TYPE_OBJECT))
#define MY_IS_OBJECT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), MY_TYPE_OBJECT))
#define MY_OBJECT_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS ((obj), MY_TYPE_OBJECT, MyObjectClass))

typedef struct _MyObject	MyObject;
typedef struct _MyObjectClass	MyObjectClass;
typedef struct _MyObjectPrivate MyObjectPrivate;

struct _MyObject
{
  ParentObject parent;

  /*< private > */
  MyObjectPrivate *priv;
};

struct _MyObjectClass
{
  ParentObjectClass parent_class;

  /* Signals */
  /* void (* signal) (MyObject *object); */
};

GType my_object_get_type(void);

/* add additional methods here */
MyObject *my_object_new(void);

G_END_DECLS

#endif /* MY_OBJECT_H */


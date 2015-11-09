# About

This demo was put together for the Leeds City Council Schools Admissions Innovation Lab held on 29th June 2015. It's
a fleshed-out version of the app presented (with these 
[slides](https://raw.githubusercontent.com/rgarner/lcc-schools/master/docs/School-Admissions.pdf)) on that day.

It is based **solely** on 2015 admissions data.

## Usage notes

* Use the "layers" button on the top right of maps to see nearest and non-nearest circles (in blue and red, respectively). 
* Use the crosshairs left of each school in a table to centre that school on the map
* In the schools list page, there's a full text search. It indexes common text fields, including postcode, so you can,
  for example, link to [all the primary schools in LS17](/schools?containing_text=LS17&phase=primary), or the 
  [thirty-three secondary schools in Leeds](/schools?phase=secondary&admissions_policy=own_admissions_policy) with their own admission policy.
  
### The traffic light system

In the tables, you'll see <span class="badge badge-contention-low">Availability</span> for schools that took in fewer children 
than their available spaces in 2015. You'll see <span class="badge badge-contention-medium">Oversubscribed</span> whenever any 
child was refused a place. And you'll see <span class="badge badge-contention-high">Not all nearest allocated</span>
when not all children for whom the school was their nearest were given a place.

## Limitations

* No shapefiles are available for historical school cutoff boundaries. This app only has circles to represent
  nearest and non-nearest admissions. A real app would combine the circles and cut-off areas.
* In the "apply for a school place" section, You get five nearest community schools and five voluntary. This needs some tweaking!
* The "layers" button isn't doing the hard work to make it simple! It's doing what was simplest on the day. 
  It does cater for the more engaged parents, but it's hiding immediately useful information. We can present that more effectively.
* No facilities, or filters for facilities (e.g. Breakfast club/cycle storage) are available.
  

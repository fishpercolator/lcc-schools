# About

This demo was put together for the Leeds City Council Schools Admissions Innovation Lab held on 29th June 2015. It's
a slightly fleshed-out version of the app presented (with these 
[slides](https://raw.githubusercontent.com/rgarner/lcc-schools/master/docs/School-Admissions.pdf)) on that day.

## Usage notes

* Use the "layers" button on the top right of maps to see nearest and non-nearest circles (in blue and red, respectively). 
* Use the crosshairs left of each school in a table to centre that school on the map
* In the schools list page, there's a full text search. It indexes common text fields, including postcode, so you can,
  for example, link to [all the primary schools in LS17](/schools?containing_text=LS17&phase=primary), or the 
  [only three secondary schools in Leeds](/schools?phase=secondary&admissions_policy=own_admissions_policy) with their own admission policy.

## Limitations

* No shapefiles are available for historical school cutoff boundaries. This app only has circles to represent
  nearest and non-nearest admissions. A real app would combine the circles and cut-off areas.
* The "apply for a school place" flow is limited to one location.
* The "layers" button isn't doing the hard work to make it simple! It's doing what was simplest on the day. 
  It does cater for the more engaged parents, but it's hiding immediately useful information. We can present that more effectively.
* No facilities, or filters for facilities (e.g. Breakfast club/cycle storage) are available.
  

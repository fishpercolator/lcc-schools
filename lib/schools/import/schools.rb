require 'csv'

module Schools
  module Import
    class Schools < Struct.new(:filename)
      
      ALLOCATED_NUMBERS = %r{([0-9]+)/([0-9]+)}

      def run!
        CSV.read(filename, headers: true).each do |row|
          School.find_or_create_by!(code: row['SchoolCode']) do |school|
            school.code = row['SchoolCode']
            school.name = row['School']
            school.phase = row['Phase']
            school.address1 = row['AddressLine1']
            school.address2 = row['AddressLine2']
            school.address3 = row['AddressLine3']
            school.telephone = row['Telephone']
            school.postcode = row['PostCode']
            school.headteacher = row['Headteacher']
            school.number_of_pupils = row['NumberOfPupils']
            school.email = row['Email']
            school.website = row['Website']
            school.ofsted_report = 'http://some.ofsted.report/'
            school.available_places = row['NumberOfPlacesAvailable']
            school.nearest = row['Nearest']
            school.non_nearest = row['Non Nearest']

            match = row['Allocated'] && row['Allocated'].match(ALLOCATED_NUMBERS)
            if match
              school.number_of_admissions = $1
            else
              school.number_of_admissions = $2.to_i / 2
            end
          end
          next if row['X_REF'] == '#N/A'

          point_wkt = "POINT(#{row['X_REF']} #{row['Y_REF']})"
          sql = <<-SQL
            UPDATE schools
            SET centroid = ST_Transform(ST_GeomFromText('#{point_wkt}', 27700), 4326)
            WHERE code='#{row['SchoolCode']}'
          SQL
          begin
            School.connection.execute(sql)
          rescue PG::InternalError
            puts "Warn: #{row['X_REF']}, #{row['Y_REF']} not a valid point"
          end
        end
      end
      
    end
  end
end

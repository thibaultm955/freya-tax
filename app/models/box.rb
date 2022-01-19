class Box < ApplicationRecord

    belongs_to :country
    belongs_to :periodicity
    belongs_to :project_type

    # Will take input periodicity to project type & a return
    # It will create the box_names for the return using the French names
    def self.create_box_names_for_return(periodicity, project_type, country, return_created)

        box_names = Box.where(periodicity_id: periodicity.id, project_type_id: project_type.id, country_id: country.id)

        box_names.each do |box_name|
            return_box = ReturnBox.new(return_id: return_created.id, box_id: box_name.id, amount: 0)
            return_box.save!
        end
    end

end

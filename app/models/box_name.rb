class BoxName < ApplicationRecord

    # Will take input periodicity to project type & a return
    # It will create the box_names for the return using the French names
    def self.create_box_names_for_return(periodicity_to_project_type, return_created)

        box_names = BoxName.where(periodicity_to_project_type_id: periodicity_to_project_type.id, language_id: 2)

        box_names.each do |box_name|
            return_box = ReturnBox.new(return_id: return_created.id, box_name_id: box_name.id, amount: 0)
            return_box.save!
        end
    end

end

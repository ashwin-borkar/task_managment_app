class Project < ApplicationRecord
	has_many :tasks
	def self.get_by_status(status)
        self.all.select do |project|
            project.status == status
        end
    end

    def update_status
        if self.tasks == []
            self.status = "Empty"
        elsif self.tasks.any?{|task| task.status == "Pending"}
            self.status = "Pending"
        else
            self.status = "Completed"
        end
        self.save
    end

    def tasks_by_status(status)
        self.tasks.select do |task|
            task.status == status
        end
    end
end

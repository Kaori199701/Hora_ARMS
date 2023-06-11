class Batch::CreateStampdate
  def self.create_stampdate
    create Attendance.stamp_date
  end
end
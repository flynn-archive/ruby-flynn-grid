require "test_helper"

class TestJobs < GridIntegrationTest
  def test_all_jobs_are_returned
    jobs = @grid.jobs
    assert_equal 6, jobs.size

    @grid.hosts.each do |host|
      jobs = host.jobs
      assert_match /^flynn-etcd/, jobs[0].id
      assert_match /^flynn-discoverd/, jobs[1].id
    end
  end

  def test_schedule_job
    jobs = @grid.jobs
    assert_equal 6, jobs.size

    @grid.schedule "app"
    jobs = @grid.jobs
    assert_equal 7, jobs.size

    first_host = @grid.hosts.first
    assert_match /^app/, first_host.jobs[2].id
  end
end

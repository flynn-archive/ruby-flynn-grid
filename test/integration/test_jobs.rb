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

  def test_schedule_job_without_filter
    jobs = @grid.jobs
    assert_equal 6, jobs.size

    @grid.schedule "app"
    jobs = @grid.jobs
    assert_equal 7, jobs.size

    first_host = @grid.hosts.first
    assert_match /^app/, first_host.jobs[2].id
  end

  def test_schedule_job_with_filter
    jobs = @grid.jobs
    assert_equal 6, jobs.size

    @grid.schedule "app", on: { name: "n2" }
    jobs = @grid.jobs
    assert_equal 7, jobs.size

    matching_host = @grid.hosts.detect { |h| h.matches?(name: "n2") }
    jobs = matching_host.jobs
    assert_equal 3, jobs.size
    assert_match /^app/, jobs[2].id
  end
end

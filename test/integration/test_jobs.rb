require "test_helper"

class TestJobs < GridIntegrationTest
  def test_all_jobs_are_returned
    jobs = @grid.jobs
    assert_equal 2, jobs.size
    assert_match /^flynn-etcd/, jobs[0].id
    assert_match /^flynn-discoverd/, jobs[1].id
  end
end

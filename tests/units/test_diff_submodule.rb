#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'

class TestDiffSubmodule < Test::Unit::TestCase
  def setup
    set_file_paths

    @top_dir = File.join(@wdir_dot, '..', 'top')
    @git = Git.open(@top_dir)
  end

  # No --submodule option - diff shows submodule commit hash only
  def test_diff
    patch = @git.diff('7ed389f7f4aba2e3cb429eb613ae196b25f2356b^', '7ed389f7f4aba2e3cb429eb613ae196b25f2356b').patch
    assert_match(/^-Subproject commit/, patch)
    assert_match(/^\+Subproject commit/, patch)
    assert_no_match(/^Submodule submod/, patch)
    assert(!patch.include?('test file in submodule'))
  end

  # --submodule=diff option - diff includes submodule diff
  def test_diff_submodule_diff
    patch = @git.diff('7ed389f7f4aba2e3cb429eb613ae196b25f2356b^', '7ed389f7f4aba2e3cb429eb613ae196b25f2356b', submodule: 'diff').patch
    assert_match(/^Submodule submod/, patch)
    assert(patch.include?('test file in submodule'))
  end


end

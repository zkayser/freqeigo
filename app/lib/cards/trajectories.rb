module Cards
  module Trajectories
    
    DEFAULT_TRAJECTORY = {
      stage_one: {
        first_review: [:reset, :add_eight_hours],
        second_review: [:reset, :add_one_day],
        third_review: [:reset, :add_one_day],
        fourth_review: [:reset, :add_one_day],
        fifth_review: [:reset, :add_one_day, :stage_up_if_pass]
      },
      stage_two: {
        first_review: [:reset, :five_per_month, :stage_down_if_fail],
        second_review: [:reset, :five_per_month],
        third_review: [:reset, :five_per_month],
        fourth_review: [:reset, :five_per_month],
        fifth_review: [:reset, :five_per_month, :stage_up_if_pass]
      },
      stage_three: {
        first_review: [:reset, :two_per_month, :stage_down_if_fail],
        second_review: [:reset, :two_per_month],
        third_review: [:reset, :two_per_month],
        fourth_review: [:reset, :two_per_month],
        fifth_review: [:reset, :two_per_month, :set_master_stage_if_pass]
      },
      master_stage: [:reset, :one_per_month, :stage_down_if_needed]
    }
    
  end
end
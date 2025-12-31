-- Migration: Insert all problems from mockData.ts into database
-- Generated from detailedProblems object
-- Total problems: 408

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  '1',
  'Two Sum',
  'two-sum',
  'easy',
  'Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.',
  '[{"input":"nums = [2,7,11,15], target = 9","output":"[0,1]","explanation":"Because nums[0] + nums[1] == 9, we return [0, 1]."},{"input":"nums = [3,2,4], target = 6","output":"[1,2]"}]'::jsonb,
  '["2 <= nums.length <= 10^4","-10^9 <= nums[i] <= 10^9","-10^9 <= target <= 10^9","Only one valid answer exists"]'::jsonb,
  '["Array","Hash Table"]'::jsonb,
  'DSA',
  '{"javascript":"function twoSum(nums, target) {\n  // Your code here\n}","python":"def two_sum(nums, target):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] twoSum(int[] nums, int target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,7,11,15], 9","expectedOutput":"[0,1]","hidden":false},{"id":"2","input":"[3,2,4], 6","expectedOutput":"[1,2]","hidden":false},{"id":"3","input":"[3,3], 6","expectedOutput":"[0,1]","hidden":false}]'::jsonb,
  '[{"id":"4","input":"[1,5,3,7,9], 12","expectedOutput":"[2,4]","hidden":true}]'::jsonb,
  '["Try using a hash map to store numbers you''ve seen","For each number, check if (target - number) exists in your hash map","Time complexity should be O(n) with single pass"]'::jsonb,
  49.2,
  '["Google","Amazon","Microsoft","Facebook","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  '4',
  'Maximum Subarray',
  'maximum-subarray',
  'medium',
  'Given an integer array `nums`, find the subarray with the largest sum, and return its sum.

A subarray is a contiguous non-empty sequence of elements within an array.',
  '[{"input":"nums = [-2,1,-3,4,-1,2,1,-5,4]","output":"6","explanation":"The subarray [4,-1,2,1] has the largest sum 6."},{"input":"nums = [1]","output":"1"},{"input":"nums = [5,4,-1,7,8]","output":"23"}]'::jsonb,
  '["1 <= nums.length <= 10^5","-10^4 <= nums[i] <= 10^4"]'::jsonb,
  '["Array","Dynamic Programming","Divide and Conquer"]'::jsonb,
  'DSA',
  '{"javascript":"function maxSubArray(nums) {\n  // Your code here\n}","python":"def max_sub_array(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxSubArray(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-2,1,-3,4,-1,2,1,-5,4]","expectedOutput":"6","hidden":false},{"id":"2","input":"[1]","expectedOutput":"1","hidden":false},{"id":"3","input":"[5,4,-1,7,8]","expectedOutput":"23","hidden":false}]'::jsonb,
  '[{"id":"4","input":"[-1,-2,-3,-4]","expectedOutput":"-1","hidden":true}]'::jsonb,
  '["Think about Kadane''s Algorithm","Keep track of the current sum and maximum sum seen so far","If current sum becomes negative, reset it to 0"]'::jsonb,
  50.8,
  '["Amazon","Microsoft","Bloomberg","LinkedIn"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'kadanes',
  'Maximum Sum Subarray of Size K',
  'kadanes',
  'easy',
  'Given an array of integers and a number k, find the maximum sum of a subarray of size k.

A subarray is a contiguous part of an array. You need to find the maximum sum among all subarrays of exactly size k.',
  '[{"input":"arr = [2, 1, 5, 1, 3, 2], k = 3","output":"9","explanation":"Subarray with maximum sum is [5, 1, 3] with sum = 9"},{"input":"arr = [2, 3, 4, 1, 5], k = 2","output":"7","explanation":"Subarray with maximum sum is [3, 4] with sum = 7"}]'::jsonb,
  '["1 <= k <= arr.length <= 10^5","-10^4 <= arr[i] <= 10^4"]'::jsonb,
  '["Array","Sliding Window"]'::jsonb,
  'DSA',
  '{"javascript":"function maxSumSubarray(arr, k) {\n  // Your code here\n}","python":"def max_sum_subarray(arr, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxSumSubarray(int[] arr, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2, 1, 5, 1, 3, 2], 3","expectedOutput":"9","hidden":false},{"id":"2","input":"[2, 3, 4, 1, 5], 2","expectedOutput":"7","hidden":false}]'::jsonb,
  '[{"id":"3","input":"[1, 4, 2, 10, 23, 3, 1, 0, 20], 4","expectedOutput":"39","hidden":true}]'::jsonb,
  '["Use sliding window technique","Calculate sum of first k elements, then slide the window","For each slide: subtract leftmost element, add new rightmost element"]'::jsonb,
  52.3,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'largest-element',
  'Find Largest Element in Array',
  'largest-element',
  'easy',
  'Given an array of integers, find and return the largest element in the array.

You need to implement a function that takes an array as input and returns the maximum value present in it.',
  '[{"input":"arr = [3, 2, 1, 5, 4]","output":"5","explanation":"5 is the largest element in the array"},{"input":"arr = [10, 20, 4, 45, 99]","output":"99","explanation":"99 is the largest element"}]'::jsonb,
  '["1 <= arr.length <= 10^5","-10^9 <= arr[i] <= 10^9"]'::jsonb,
  '["Array","Basics"]'::jsonb,
  'DSA',
  '{"javascript":"function findLargest(arr) {\n  // Your code here\n}","python":"def find_largest(arr):\n    # Your code here\n    pass","java":"class Solution {\n    public int findLargest(int[] arr) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3, 2, 1, 5, 4]","expectedOutput":"5","hidden":false},{"id":"2","input":"[10, 20, 4, 45, 99]","expectedOutput":"99","hidden":false},{"id":"3","input":"[-1, -5, -3]","expectedOutput":"-1","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Initialize a variable with the first element","Iterate through the array and update max when you find larger element","Time complexity should be O(n)"]'::jsonb,
  85.5,
  '["Amazon","Microsoft"]'::jsonb,
  1,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-search',
  'Binary Search',
  'binary-search',
  'easy',
  'Given a sorted array of integers `nums` and an integer `target`, write a function to search for `target` in `nums`. If `target` exists, return its index. Otherwise, return -1.

You must write an algorithm with O(log n) runtime complexity.',
  '[{"input":"nums = [-1,0,3,5,9,12], target = 9","output":"4","explanation":"9 exists in nums and its index is 4"},{"input":"nums = [-1,0,3,5,9,12], target = 2","output":"-1","explanation":"2 does not exist in nums so return -1"}]'::jsonb,
  '["1 <= nums.length <= 10^4","-10^4 < nums[i], target < 10^4","All integers in nums are unique","nums is sorted in ascending order"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function binarySearch(nums, target) {\n  // Your code here\n}","python":"def binary_search(nums, target):\n    # Your code here\n    pass","java":"class Solution {\n    public int binarySearch(int[] nums, int target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-1,0,3,5,9,12], 9","expectedOutput":"4","hidden":false},{"id":"2","input":"[-1,0,3,5,9,12], 2","expectedOutput":"-1","hidden":false},{"id":"3","input":"[5], 5","expectedOutput":"0","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers: left and right to define search space","Calculate middle index: mid = (left + right) / 2","If nums[mid] == target, return mid. If nums[mid] < target, search right half, else search left half"]'::jsonb,
  56.1,
  '["Google","Amazon","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-linkedlist',
  'Reverse Linked List',
  'reverse-linkedlist',
  'easy',
  'Given the head of a singly linked list, reverse the list, and return the reversed list.

You need to reverse the links between nodes to reverse the entire list.',
  '[{"input":"head = [1,2,3,4,5]","output":"[5,4,3,2,1]","explanation":"The linked list is reversed"},{"input":"head = [1,2]","output":"[2,1]"},{"input":"head = []","output":"[]"}]'::jsonb,
  '["The number of nodes in the list is in range [0, 5000]","-5000 <= Node.val <= 5000"]'::jsonb,
  '["Linked List","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseList(head) {\n  // Your code here\n}","python":"def reverse_list(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode reverseList(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5]","expectedOutput":"[5,4,3,2,1]","hidden":false},{"id":"2","input":"[1,2]","expectedOutput":"[2,1]","hidden":false},{"id":"3","input":"[]","expectedOutput":"[]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use three pointers: prev, current, and next","Iterate through list, reversing links one by one","Can also solve using recursion"]'::jsonb,
  72.8,
  '["Amazon","Microsoft","Facebook","Apple","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'valid-parentheses',
  'Valid Parentheses',
  'valid-parentheses',
  'easy',
  'Given a string s containing just the characters ''('', '')'', ''{'', ''}'', ''['' and '']'', determine if the input string is valid. An input string is valid if: Open brackets must be closed by the same type of brackets, Open brackets must be closed in the correct order, Every close bracket has a corresponding open bracket of the same type.',
  '[{"input":"s = \"()\"","output":"true"},{"input":"s = \"()[]{}\"","output":"true"},{"input":"s = \"(]\"","output":"false"}]'::jsonb,
  '["1 <= s.length <= 10^4","s consists of parentheses only ''()[]{}''"]'::jsonb,
  '["String","Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function isValid(s) {\n  // Your code here\n}","python":"def is_valid(s):\n    pass","java":"class Solution {\n    public boolean isValid(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"()\"","expectedOutput":"true","hidden":false},{"id":"2","input":"\"()[]{}\"","expectedOutput":"true","hidden":false},{"id":"3","input":"\"(]\"","expectedOutput":"false","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to match opening brackets","Use hashmap for bracket pairs"]'::jsonb,
  40.3,
  '["Amazon","Microsoft","Facebook","Google","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'merge-sorted-array',
  'Merge Sorted Array',
  'merge-sorted-array',
  'easy',
  'You are given two integer arrays nums1 and nums2, sorted in non-decreasing order, and two integers m and n, representing the number of elements in nums1 and nums2 respectively.

Merge nums1 and nums2 into a single array sorted in non-decreasing order.',
  '[{"input":"nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3","output":"[1,2,2,3,5,6]"}]'::jsonb,
  '["nums1.length == m + n"]'::jsonb,
  '["Array","Two Pointers","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function merge(nums1, m, nums2, n) {\n  // Your code here\n}","python":"def merge(nums1, m, nums2, n):\n    pass","java":"class Solution {\n    public void merge(int[] nums1, int m, int[] nums2, int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,0,0,0], 3, [2,5,6], 3","expectedOutput":"[1,2,2,3,5,6]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Start from the end","Compare and place larger elements"]'::jsonb,
  46.2,
  '["Facebook","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'valid-palindrome',
  'Valid Palindrome',
  'valid-palindrome',
  'easy',
  'A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward.',
  '[{"input":"s = \"A man, a plan, a canal: Panama\"","output":"true"}]'::jsonb,
  '["1 <= s.length <= 2 * 10^5"]'::jsonb,
  '["Two Pointers","String"]'::jsonb,
  'DSA',
  '{"javascript":"function isPalindrome(s) {\n  // Your code here\n}","python":"def is_palindrome(s):\n    pass","java":"class Solution {\n    public boolean isPalindrome(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"A man, a plan, a canal: Panama\"","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers","Skip non-alphanumeric characters"]'::jsonb,
  44.1,
  '["Facebook","Microsoft","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  '3sum',
  '3Sum',
  '3sum',
  'medium',
  'Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.',
  '[{"input":"nums = [-1,0,1,2,-1,-4]","output":"[[-1,-1,2],[-1,0,1]]"}]'::jsonb,
  '["3 <= nums.length <= 3000"]'::jsonb,
  '["Array","Two Pointers","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function threeSum(nums) {\n  // Your code here\n}","python":"def three_sum(nums):\n    pass","java":"class Solution {\n    public List<List<Integer>> threeSum(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-1,0,1,2,-1,-4]","expectedOutput":"[[-1,-1,2],[-1,0,1]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort the array first","Fix one element and use two pointers"]'::jsonb,
  32.8,
  '["Facebook","Amazon","Microsoft","Bloomberg"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sort-colors',
  'Sort Colors',
  'sort-colors',
  'medium',
  'Given an array nums with n objects colored red, white, or blue, sort them in-place so that objects of the same color are adjacent, with the colors in the order red, white, and blue. We will use the integers 0, 1, and 2 to represent the color red, white, and blue, respectively.',
  '[{"input":"nums = [2,0,2,1,1,0]","output":"[0,0,1,1,2,2]"}]'::jsonb,
  '["n == nums.length","1 <= n <= 300"]'::jsonb,
  '["Array","Two Pointers","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function sortColors(nums) {\n  // Your code here\n}","python":"def sort_colors(nums):\n    pass","java":"class Solution {\n    public void sortColors(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,0,2,1,1,0]","expectedOutput":"[0,0,1,1,2,2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Dutch National Flag algorithm","Use three pointers"]'::jsonb,
  59.7,
  '["Microsoft","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-nth-node',
  'Remove Nth Node From End of List',
  'remove-nth-node',
  'medium',
  'Given the head of a linked list, remove the `nth` node from the end of the list and return its head.',
  '[{"input":"head = [1,2,3,4,5], n = 2","output":"[1,2,3,5]","explanation":"Remove the 2nd node from the end"},{"input":"head = [1], n = 1","output":"[]"},{"input":"head = [1,2], n = 1","output":"[1]"}]'::jsonb,
  '["The number of nodes in the list is sz.","1 <= sz <= 30","0 <= Node.val <= 100","1 <= n <= sz"]'::jsonb,
  '["Linked List","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function removeNthFromEnd(head, n) {\n  // Your code here\n}","python":"def remove_nth_from_end(head, n):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode removeNthFromEnd(ListNode head, int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5], 2","expectedOutput":"[1,2,3,5]","hidden":false},{"id":"2","input":"[1], 1","expectedOutput":"[]","hidden":false},{"id":"3","input":"[1,2], 1","expectedOutput":"[1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers with n gap between them","Move both pointers until the fast pointer reaches end","The slow pointer will be at the node before the one to remove"]'::jsonb,
  42.9,
  '["Amazon","Microsoft","Facebook","Apple","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-words',
  'Reverse Words in a String',
  'reverse-words',
  'medium',
  'Given an input string `s`, reverse the order of the words.

A word is defined as a sequence of non-space characters. The words in `s` will be separated by at least one space.

Return a string of the words in reverse order concatenated by a single space.

Note that `s` may contain leading or trailing spaces or multiple spaces between two words. The returned string should only have a single space separating the words. Do not include any extra spaces.',
  '[{"input":"s = \"the sky is blue\"","output":"\"blue is sky the\""},{"input":"s = \"  hello world  \"","output":"\"world hello\"","explanation":"Your reversed string should not contain leading or trailing spaces."},{"input":"s = \"a good   example\"","output":"\"example good a\"","explanation":"You need to reduce multiple spaces between two words to a single space in the reversed string."}]'::jsonb,
  '["1 <= s.length <= 10^4","s contains English letters (upper-case and lower-case), digits, and spaces '' ''.","There is at least one word in s."]'::jsonb,
  '["Two Pointers","String"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseWords(s) {\n  // Your code here\n}","python":"def reverse_words(s):\n    # Your code here\n    pass","java":"class Solution {\n    public String reverseWords(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"the sky is blue\"","expectedOutput":"\"blue is sky the\"","hidden":false},{"id":"2","input":"\"  hello world  \"","expectedOutput":"\"world hello\"","hidden":false},{"id":"3","input":"\"a good   example\"","expectedOutput":"\"example good a\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Split the string by spaces and filter out empty strings","Reverse the array of words","Join them back with a single space"]'::jsonb,
  35.2,
  '["Microsoft","Amazon","Facebook","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'happy-number',
  'Happy Number',
  'happy-number',
  'easy',
  'Write an algorithm to determine if a number `n` is happy.

A happy number is a number defined by the following process:
- Starting with any positive integer, replace the number by the sum of the squares of its digits.
- Repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which does not include 1.
- Those numbers for which this process ends in 1 are happy.

Return `true` if `n` is a happy number, and `false` if not.',
  '[{"input":"n = 19","output":"true","explanation":"1² + 9² = 82\n8² + 2² = 68\n6² + 8² = 100\n1² + 0² + 0² = 1"},{"input":"n = 2","output":"false"}]'::jsonb,
  '["1 <= n <= 2^31 - 1"]'::jsonb,
  '["Hash Table","Math","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function isHappy(n) {\n  // Your code here\n}","python":"def is_happy(n):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean isHappy(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"19","expectedOutput":"true","hidden":false},{"id":"2","input":"2","expectedOutput":"false","hidden":false},{"id":"3","input":"7","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use fast and slow pointer technique to detect cycle","Slow pointer moves one step, fast pointer moves two steps","If they meet and not at 1, there''s a cycle"]'::jsonb,
  54.8,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'linked-list-cycle',
  'Linked List Cycle',
  'linked-list-cycle',
  'easy',
  'Given `head`, the head of a linked list, determine if the linked list has a cycle in it.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer. Internally, `pos` is used to denote the index of the node that tail''s `next` pointer is connected to. Note that `pos` is not passed as a parameter.

Return `true` if there is a cycle in the linked list. Otherwise, return `false`.',
  '[{"input":"head = [3,2,0,-4], pos = 1","output":"true","explanation":"There is a cycle in the linked list, where the tail connects to the 1st node (0-indexed)."},{"input":"head = [1,2], pos = 0","output":"true","explanation":"There is a cycle in the linked list, where the tail connects to the 0th node."},{"input":"head = [1], pos = -1","output":"false","explanation":"There is no cycle in the linked list."}]'::jsonb,
  '["The number of the nodes in the list is in the range [0, 10^4]","-10^5 <= Node.val <= 10^5","pos is -1 or a valid index in the linked-list"]'::jsonb,
  '["Hash Table","Linked List","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function hasCycle(head) {\n  // Your code here\n}","python":"def has_cycle(head):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean hasCycle(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,2,0,-4], pos = 1","expectedOutput":"true","hidden":false},{"id":"2","input":"[1,2], pos = 0","expectedOutput":"true","hidden":false},{"id":"3","input":"[1], pos = -1","expectedOutput":"false","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use Floyd''s Cycle Detection Algorithm (Tortoise and Hare)","Use two pointers: slow moves 1 step, fast moves 2 steps","If fast meets slow, there''s a cycle"]'::jsonb,
  48.2,
  '["Amazon","Microsoft","Bloomberg","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'middle-linked-list',
  'Middle of the Linked List',
  'middle-linked-list',
  'easy',
  'Given the `head` of a singly linked list, return the middle node of the linked list.

If there are two middle nodes, return the second middle node.',
  '[{"input":"head = [1,2,3,4,5]","output":"[3,4,5]","explanation":"The middle node of the list is node 3."},{"input":"head = [1,2,3,4,5,6]","output":"[4,5,6]","explanation":"Since the list has two middle nodes with values 3 and 4, we return the second one."}]'::jsonb,
  '["The number of nodes in the list is in the range [1, 100]","1 <= Node.val <= 100"]'::jsonb,
  '["Linked List","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function middleNode(head) {\n  // Your code here\n}","python":"def middle_node(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode middleNode(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5]","expectedOutput":"[3,4,5]","hidden":false},{"id":"2","input":"[1,2,3,4,5,6]","expectedOutput":"[4,5,6]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use fast and slow pointers","Slow pointer moves 1 step, fast pointer moves 2 steps","When fast reaches end, slow is at middle"]'::jsonb,
  74.6,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-duplicate-number',
  'Find the Duplicate Number',
  'find-duplicate-number',
  'medium',
  'Given an array of integers `nums` containing `n + 1` integers where each integer is in the range `[1, n]` inclusive.

There is only one repeated number in `nums`, return this repeated number.

You must solve the problem without modifying the array `nums` and uses only constant extra space.',
  '[{"input":"nums = [1,3,4,2,2]","output":"2"},{"input":"nums = [3,1,3,4,2]","output":"3"}]'::jsonb,
  '["1 <= n <= 10^5","nums.length == n + 1","1 <= nums[i] <= n","All the integers in nums appear only once except for precisely one integer which appears two or more times"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function findDuplicate(nums) {\n  // Your code here\n}","python":"def find_duplicate(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int findDuplicate(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,3,4,2,2]","expectedOutput":"2","hidden":false},{"id":"2","input":"[3,1,3,4,2]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[{"id":"3","input":"[2,5,9,6,9,3,8,9,7,1,4]","expectedOutput":"9","hidden":true}]'::jsonb,
  '["Think of the array as a linked list where nums[i] points to index nums[i]","Use Floyd''s Cycle Detection Algorithm","Find the cycle entry point which is the duplicate number"]'::jsonb,
  59.8,
  '["Amazon","Microsoft","Apple","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'linked-list-cycle-ii',
  'Linked List Cycle II',
  'linked-list-cycle-ii',
  'medium',
  'Given the `head` of a linked list, return the node where the cycle begins. If there is no cycle, return `null`.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer. Internally, `pos` is used to denote the index of the node that tail''s `next` pointer is connected to (0-indexed). It is `-1` if there is no cycle. Note that `pos` is not passed as a parameter.

Do not modify the linked list.',
  '[{"input":"head = [3,2,0,-4], pos = 1","output":"tail connects to node index 1","explanation":"There is a cycle in the linked list, where tail connects to the second node."},{"input":"head = [1,2], pos = 0","output":"tail connects to node index 0","explanation":"There is a cycle in the linked list, where tail connects to the first node."},{"input":"head = [1], pos = -1","output":"no cycle","explanation":"There is no cycle in the linked list."}]'::jsonb,
  '["The number of the nodes in the list is in the range [0, 10^4]","-10^5 <= Node.val <= 10^5","pos is -1 or a valid index in the linked-list"]'::jsonb,
  '["Hash Table","Linked List","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function detectCycle(head) {\n  // Your code here\n}","python":"def detect_cycle(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode detectCycle(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,2,0,-4], pos = 1","expectedOutput":"1","hidden":false},{"id":"2","input":"[1,2], pos = 0","expectedOutput":"0","hidden":false},{"id":"3","input":"[1], pos = -1","expectedOutput":"null","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["First detect if cycle exists using fast and slow pointers","Once they meet, reset one pointer to head","Move both pointers one step at a time, they''ll meet at cycle start"]'::jsonb,
  47.5,
  '["Amazon","Microsoft","Facebook","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-substring-no-repeat',
  'Longest Substring Without Repeating Characters',
  'longest-substring-no-repeat',
  'medium',
  'Given a string `s`, find the length of the longest substring without repeating characters.',
  '[{"input":"s = \"abcabcbb\"","output":"3","explanation":"The answer is \"abc\", with the length of 3."},{"input":"s = \"bbbbb\"","output":"1","explanation":"The answer is \"b\", with the length of 1."},{"input":"s = \"pwwkew\"","output":"3","explanation":"The answer is \"wke\", with the length of 3. Notice that the answer must be a substring, \"pwke\" is a subsequence and not a substring."}]'::jsonb,
  '["0 <= s.length <= 5 * 10^4","s consists of English letters, digits, symbols and spaces."]'::jsonb,
  '["Hash Table","String","Sliding Window"]'::jsonb,
  'DSA',
  '{"javascript":"function lengthOfLongestSubstring(s) {\n  // Your code here\n}","python":"def length_of_longest_substring(s):\n    # Your code here\n    pass","java":"class Solution {\n    public int lengthOfLongestSubstring(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abcabcbb\"","expectedOutput":"3","hidden":false},{"id":"2","input":"\"bbbbb\"","expectedOutput":"1","hidden":false},{"id":"3","input":"\"pwwkew\"","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use sliding window with a hash set or hash map","Expand window by moving right pointer, shrink when duplicate found","Track maximum window size seen"]'::jsonb,
  33.8,
  '["Amazon","Facebook","Microsoft","Bloomberg","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-window-substring',
  'Minimum Window Substring',
  'minimum-window-substring',
  'hard',
  'Given two strings `s` and `t` of lengths `m` and `n` respectively, return the minimum window substring of `s` such that every character in `t` (including duplicates) is included in the window. If there is no such substring, return the empty string `""`.

The testcases will be generated such that the answer is unique.',
  '[{"input":"s = \"ADOBECODEBANC\", t = \"ABC\"","output":"\"BANC\"","explanation":"The minimum window substring \"BANC\" includes ''A'', ''B'', and ''C'' from string t."},{"input":"s = \"a\", t = \"a\"","output":"\"a\"","explanation":"The entire string s is the minimum window."},{"input":"s = \"a\", t = \"aa\"","output":"\"\"","explanation":"Both ''a''s from t must be included in the window. Since the largest window of s only has one ''a'', return empty string."}]'::jsonb,
  '["m == s.length","n == t.length","1 <= m, n <= 10^5","s and t consist of uppercase and lowercase English letters"]'::jsonb,
  '["Hash Table","String","Sliding Window"]'::jsonb,
  'DSA',
  '{"javascript":"function minWindow(s, t) {\n  // Your code here\n}","python":"def min_window(s, t):\n    # Your code here\n    pass","java":"class Solution {\n    public String minWindow(String s, String t) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"ADOBECODEBANC\", \"ABC\"","expectedOutput":"\"BANC\"","hidden":false},{"id":"2","input":"\"a\", \"a\"","expectedOutput":"\"a\"","hidden":false},{"id":"3","input":"\"a\", \"aa\"","expectedOutput":"\"\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers and a hash map to count characters","Expand window until all characters of t are included","Then shrink window from left while maintaining all characters"]'::jsonb,
  40.2,
  '["Facebook","Amazon","Microsoft","LinkedIn"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sliding-window-maximum',
  'Sliding Window Maximum',
  'sliding-window-maximum',
  'hard',
  'You are given an array of integers `nums`, there is a sliding window of size `k` which is moving from the very left of the array to the very right. You can only see the `k` numbers in the window. Each time the sliding window moves right by one position.

Return the max sliding window.',
  '[{"input":"nums = [1,3,-1,-3,5,3,6,7], k = 3","output":"[3,3,5,5,6,7]","explanation":"Window position                Max\n---------------               -----\n[1  3  -1] -3  5  3  6  7       3\n 1 [3  -1  -3] 5  3  6  7       3\n 1  3 [-1  -3  5] 3  6  7       5\n 1  3  -1 [-3  5  3] 6  7       5\n 1  3  -1  -3 [5  3  6] 7       6\n 1  3  -1  -3  5 [3  6  7]      7"},{"input":"nums = [1], k = 1","output":"[1]"}]'::jsonb,
  '["1 <= nums.length <= 10^5","-10^4 <= nums[i] <= 10^4","1 <= k <= nums.length"]'::jsonb,
  '["Array","Queue","Sliding Window","Heap","Monotonic Queue"]'::jsonb,
  'DSA',
  '{"javascript":"function maxSlidingWindow(nums, k) {\n  // Your code here\n}","python":"def max_sliding_window(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] maxSlidingWindow(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,3,-1,-3,5,3,6,7], 3","expectedOutput":"[3,3,5,5,6,7]","hidden":false},{"id":"2","input":"[1], 1","expectedOutput":"[1]","hidden":false}]'::jsonb,
  '[{"id":"3","input":"[1,-1], 1","expectedOutput":"[1,-1]","hidden":true}]'::jsonb,
  '["Use a deque (double-ended queue) to store indices","Keep deque in decreasing order of values","Remove indices outside current window from front"]'::jsonb,
  46.3,
  '["Amazon","Google","Microsoft","Facebook"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-repeating-character',
  'Longest Repeating Character Replacement',
  'longest-repeating-character',
  'medium',
  'You are given a string `s` and an integer `k`. You can choose any character of the string and change it to any other uppercase English character. You can perform this operation at most `k` times.

Return the length of the longest substring containing the same letter you can get after performing the above operations.',
  '[{"input":"s = \"ABAB\", k = 2","output":"4","explanation":"Replace the two ''A''s with two ''B''s or vice versa."},{"input":"s = \"AABABBA\", k = 1","output":"4","explanation":"Replace the one ''A'' in the middle with ''B'' and form \"AABBBBA\". The substring \"BBBB\" has the longest repeating letters, which is 4."}]'::jsonb,
  '["1 <= s.length <= 10^5","s consists of only uppercase English letters.","0 <= k <= s.length"]'::jsonb,
  '["Hash Table","String","Sliding Window"]'::jsonb,
  'DSA',
  '{"javascript":"function characterReplacement(s, k) {\n  // Your code here\n}","python":"def character_replacement(s, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int characterReplacement(String s, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"ABAB\", 2","expectedOutput":"4","hidden":false},{"id":"2","input":"\"AABABBA\", 1","expectedOutput":"4","hidden":false}]'::jsonb,
  '[{"id":"3","input":"\"AAAA\", 0","expectedOutput":"4","hidden":true}]'::jsonb,
  '["Use sliding window with character frequency map","Window is valid if: windowSize - maxFrequency <= k","Expand window and shrink when invalid"]'::jsonb,
  51.7,
  '["Amazon","Microsoft","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-size-subarray-sum',
  'Minimum Size Subarray Sum',
  'minimum-size-subarray-sum',
  'medium',
  'Given an array of positive integers `nums` and a positive integer `target`, return the minimal length of a subarray whose sum is greater than or equal to `target`. If there is no such subarray, return `0` instead.',
  '[{"input":"target = 7, nums = [2,3,1,2,4,3]","output":"2","explanation":"The subarray [4,3] has the minimal length under the problem constraint."},{"input":"target = 4, nums = [1,4,4]","output":"1"},{"input":"target = 11, nums = [1,1,1,1,1,1,1,1]","output":"0"}]'::jsonb,
  '["1 <= target <= 10^9","1 <= nums.length <= 10^5","1 <= nums[i] <= 10^4"]'::jsonb,
  '["Array","Binary Search","Sliding Window","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function minSubArrayLen(target, nums) {\n  // Your code here\n}","python":"def min_sub_array_len(target, nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int minSubArrayLen(int target, int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"7, [2,3,1,2,4,3]","expectedOutput":"2","hidden":false},{"id":"2","input":"4, [1,4,4]","expectedOutput":"1","hidden":false},{"id":"3","input":"11, [1,1,1,1,1,1,1,1]","expectedOutput":"0","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use sliding window with two pointers","Expand window by adding elements until sum >= target","Then shrink window from left to find minimal length"]'::jsonb,
  45.9,
  '["Amazon","Facebook","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'repeated-dna-sequences',
  'Repeated DNA Sequences',
  'repeated-dna-sequences',
  'medium',
  'The DNA sequence is composed of a series of nucleotides abbreviated as ''A'', ''C'', ''G'', and ''T''.

For example, "ACGAATTCCG" is a DNA sequence.
When studying DNA, it is useful to identify repeated sequences within the DNA.

Given a string `s` that represents a DNA sequence, return all the 10-letter-long sequences (substrings) that occur more than once in a DNA molecule. You may return the answer in any order.',
  '[{"input":"s = \"AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT\"","output":"[\"AAAAACCCCC\",\"CCCCCAAAAA\"]"},{"input":"s = \"AAAAAAAAAAAAA\"","output":"[\"AAAAAAAAAA\"]"}]'::jsonb,
  '["1 <= s.length <= 10^5","s[i] is either ''A'', ''C'', ''G'', or ''T''."]'::jsonb,
  '["Hash Table","String","Bit Manipulation","Sliding Window","Rolling Hash"]'::jsonb,
  'DSA',
  '{"javascript":"function findRepeatedDnaSequences(s) {\n  // Your code here\n}","python":"def find_repeated_dna_sequences(s):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> findRepeatedDnaSequences(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT\"","expectedOutput":"[\"AAAAACCCCC\",\"CCCCCAAAAA\"]","hidden":false},{"id":"2","input":"\"AAAAAAAAAAAAA\"","expectedOutput":"[\"AAAAAAAAAA\"]","hidden":false}]'::jsonb,
  '[{"id":"3","input":"\"AAAAAAAAAAA\"","expectedOutput":"[\"AAAAAAAAAA\"]","hidden":true}]'::jsonb,
  '["Use a sliding window of size 10","Use a hash set to track seen sequences","Use another set to track sequences that appear more than once"]'::jsonb,
  47.8,
  '["LinkedIn","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'merge-intervals',
  'Merge Intervals',
  'merge-intervals',
  'medium',
  'Given an array of `intervals` where `intervals[i] = [starti, endi]`, merge all overlapping intervals, and return an array of the non-overlapping intervals that cover all the intervals in the input.',
  '[{"input":"intervals = [[1,3],[2,6],[8,10],[15,18]]","output":"[[1,6],[8,10],[15,18]]","explanation":"Since intervals [1,3] and [2,6] overlap, merge them into [1,6]."},{"input":"intervals = [[1,4],[4,5]]","output":"[[1,5]]","explanation":"Intervals [1,4] and [4,5] are considered overlapping."}]'::jsonb,
  '["1 <= intervals.length <= 10^4","intervals[i].length == 2","0 <= starti <= endi <= 10^4"]'::jsonb,
  '["Array","Sorting","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function merge(intervals) {\n  // Your code here\n}","python":"def merge(intervals):\n    # Your code here\n    pass","java":"class Solution {\n    public int[][] merge(int[][] intervals) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,3],[2,6],[8,10],[15,18]]","output":"[[1,6],[8,10],[15,18]]"},{"input":"[[1,4],[4,5]]","output":"[[1,5]]"}]'::jsonb,
  '[]'::jsonb,
  '["Sort the intervals by their start time.","Iterate through the sorted intervals and merge overlapping ones.","Keep track of the current interval being built."]'::jsonb,
  46.3,
  '["Facebook","Google","Amazon","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'insert-interval',
  'Insert Interval',
  'insert-interval',
  'medium',
  'You are given an array of non-overlapping intervals `intervals` where `intervals[i] = [starti, endi]` represent the start and the end of the `ith` interval and `intervals` is sorted in ascending order by `starti`. You are also given an interval `newInterval = [start, end]` that represents the start and end of another interval.

Insert `newInterval` into `intervals` such that `intervals` is still sorted in ascending order by `starti` and `intervals` still does not have any overlapping intervals (merge overlapping intervals if necessary).

Return `intervals` after the insertion.',
  '[{"input":"intervals = [[1,3],[6,9]], newInterval = [2,5]","output":"[[1,5],[6,9]]"},{"input":"intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]","output":"[[1,2],[3,10],[12,16]]","explanation":"Because the new interval [4,8] overlaps with [3,5],[6,7],[8,10]."}]'::jsonb,
  '["0 <= intervals.length <= 10^4","intervals[i].length == 2","0 <= starti <= endi <= 10^5","intervals is sorted by starti in ascending order","newInterval.length == 2","0 <= start <= end <= 10^5"]'::jsonb,
  '["Array","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function insert(intervals, newInterval) {\n  // Your code here\n}","python":"def insert(intervals, newInterval):\n    # Your code here\n    pass","java":"class Solution {\n    public int[][] insert(int[][] intervals, int[] newInterval) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,3],[6,9]], [2,5]","output":"[[1,5],[6,9]]"},{"input":"[[1,2],[3,5],[6,7],[8,10],[12,16]], [4,8]","output":"[[1,2],[3,10],[12,16]]"}]'::jsonb,
  '[]'::jsonb,
  '["Add all intervals that end before the new interval starts.","Merge all overlapping intervals with the new interval.","Add all remaining intervals that start after the new interval ends."]'::jsonb,
  39.2,
  '["Google","Facebook","LinkedIn","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'interval-list-intersections',
  'Interval List Intersections',
  'interval-list-intersections',
  'medium',
  'You are given two lists of closed intervals, `firstList` and `secondList`, where `firstList[i] = [starti, endi]` and `secondList[j] = [startj, endj]`. Each list of intervals is pairwise disjoint and in sorted order.

Return the intersection of these two interval lists.

A closed interval `[a, b]` (with `a <= b`) denotes the set of real numbers `x` with `a <= x <= b`.

The intersection of two closed intervals is a set of real numbers that are either empty or represented as a closed interval. For example, the intersection of `[1, 3]` and `[2, 4]` is `[2, 3]`.',
  '[{"input":"firstList = [[0,2],[5,10],[13,23],[24,25]], secondList = [[1,5],[8,12],[15,24],[25,26]]","output":"[[1,2],[5,5],[8,10],[15,23],[24,24],[25,25]]"},{"input":"firstList = [[1,3],[5,9]], secondList = []","output":"[]"}]'::jsonb,
  '["0 <= firstList.length, secondList.length <= 1000","firstList.length + secondList.length >= 1","0 <= starti < endi <= 10^9","endi < starti+1","0 <= startj < endj <= 10^9","endj < startj+1"]'::jsonb,
  '["Array","Two Pointers","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function intervalIntersection(firstList, secondList) {\n  // Your code here\n}","python":"def intervalIntersection(firstList, secondList):\n    # Your code here\n    pass","java":"class Solution {\n    public int[][] intervalIntersection(int[][] firstList, int[][] secondList) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[0,2],[5,10],[13,23],[24,25]], [[1,5],[8,12],[15,24],[25,26]]","output":"[[1,2],[5,5],[8,10],[15,23],[24,24],[25,25]]"},{"input":"[[1,3],[5,9]], []","output":"[]"}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers to iterate through both lists.","Find the intersection by taking max of start times and min of end times.","Move the pointer of the interval that ends first."]'::jsonb,
  71.3,
  '["Facebook","Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'count-days-without-meetings-1',
  'Count Days Without Meetings (Approach 1)',
  'count-days-without-meetings-1',
  'medium',
  'You are given a positive integer `days` representing the total number of days an employee is available for work (starting from day 1). You are also given a 2D array `meetings` of size `n` where, `meetings[i] = [start_i, end_i]` represents the starting and ending days of meeting `i` (inclusive).

Return the count of days when the employee is available for work but no meetings are scheduled.

Note: The meetings may overlap.',
  '[{"input":"days = 10, meetings = [[5,7],[1,3],[9,10]]","output":"2","explanation":"There is no meeting scheduled on the 4th and 8th days."},{"input":"days = 5, meetings = [[2,4],[1,3]]","output":"1","explanation":"There is no meeting scheduled on the 5th day."}]'::jsonb,
  '["1 <= days <= 10^9","1 <= meetings.length <= 10^5","meetings[i].length == 2","1 <= meetings[i][0] <= meetings[i][1] <= days"]'::jsonb,
  '["Array","Sorting","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function countDays(days, meetings) {\n  // Your code here\n}","python":"def countDays(days, meetings):\n    # Your code here\n    pass","java":"class Solution {\n    public int countDays(int days, int[][] meetings) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"10, [[5,7],[1,3],[9,10]]","output":"2"},{"input":"5, [[2,4],[1,3]]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Sort the meetings by start time.","Merge overlapping meetings.","Count the gaps between merged meetings."]'::jsonb,
  52.1,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-covered-intervals',
  'Remove Covered Intervals',
  'remove-covered-intervals',
  'medium',
  'Given an array `intervals` where `intervals[i] = [li, ri]` represent the interval `[li, ri)`, remove all intervals that are covered by another interval in the list.

The interval `[a, b)` is covered by the interval `[c, d)` if and only if `c <= a` and `b <= d`.

Return the number of remaining intervals.',
  '[{"input":"intervals = [[1,4],[3,6],[2,8]]","output":"2","explanation":"Interval [3,6] is covered by [2,8], therefore it is removed."},{"input":"intervals = [[1,4],[2,3]]","output":"1","explanation":"Interval [2,3] is covered by [1,4]."}]'::jsonb,
  '["1 <= intervals.length <= 1000","intervals[i].length == 2","0 <= li < ri <= 10^5","All the given intervals are unique"]'::jsonb,
  '["Array","Sorting","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function removeCoveredIntervals(intervals) {\n  // Your code here\n}","python":"def removeCoveredIntervals(intervals):\n    # Your code here\n    pass","java":"class Solution {\n    public int removeCoveredIntervals(int[][] intervals) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,4],[3,6],[2,8]]","output":"2"},{"input":"[[1,4],[2,3]]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Sort intervals by start time, and by end time in descending order if start times are equal.","Iterate and keep track of the maximum end time seen so far.","If current interval''s end time is less than or equal to max end, it''s covered."]'::jsonb,
  56.7,
  '["Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'car-pooling',
  '1094. Car Pooling',
  'car-pooling',
  'medium',
  'There is a car with capacity empty seats. The vehicle only drives east (i.e., it cannot turn around and drive west). You are given the integer capacity and an array trips where trips[i] = [numPassengersi, fromi, toi] indicates that the ith trip has numPassengersi passengers and the locations to pick them up and drop them off are fromi and toi respectively. The locations are given as the number of kilometers due east from the car''s initial location. Return true if it is possible to pick up and drop off all passengers for all the given trips, or false otherwise.',
  '[{"input":"trips = [[2,1,5],[3,3,7]], capacity = 4","output":"false"},{"input":"trips = [[2,1,5],[3,3,7]], capacity = 5","output":"true"}]'::jsonb,
  '["1 <= trips.length <= 1000","trips[i].length == 3","1 <= numPassengersi <= 100","0 <= fromi < toi <= 1000","1 <= capacity <= 10^5"]'::jsonb,
  '["Array","Sorting","Heap (Priority Queue)","Simulation","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function carPooling(trips, capacity) {\n  // Your code here\n}","python":"def car_pooling(trips, capacity):\n    pass","java":"class Solution {\n    public boolean carPooling(int[][] trips, int capacity) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[2,1,5],[3,3,7]], 4","expectedOutput":"false","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use difference array for passenger changes","Check if capacity exceeded at any point"]'::jsonb,
  59.8,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'data-stream-disjoint-intervals',
  'Data Stream as Disjoint Intervals',
  'data-stream-disjoint-intervals',
  'hard',
  'Given a data stream input of non-negative integers `a1, a2, ..., an`, summarize the numbers seen so far as a list of disjoint intervals.

Implement the `SummaryRanges` class:

- `SummaryRanges()` Initializes the object with an empty stream.
- `void addNum(int value)` Adds the integer `value` to the stream.
- `int[][] getIntervals()` Returns a summary of the integers in the stream currently as a list of disjoint intervals `[starti, endi]`. The answer should be sorted by `starti`.',
  '[{"input":"[\"SummaryRanges\", \"addNum\", \"getIntervals\", \"addNum\", \"getIntervals\", \"addNum\", \"getIntervals\", \"addNum\", \"getIntervals\", \"addNum\", \"getIntervals\"]\n[[], [1], [], [3], [], [7], [], [2], [], [6], []]","output":"[null, null, [[1, 1]], null, [[1, 1], [3, 3]], null, [[1, 1], [3, 3], [7, 7]], null, [[1, 3], [7, 7]], null, [[1, 3], [6, 7]]]","explanation":"SummaryRanges summaryRanges = new SummaryRanges();\nsummaryRanges.addNum(1);      // arr = [1]\nsummaryRanges.getIntervals(); // return [[1, 1]]\nsummaryRanges.addNum(3);      // arr = [1, 3]\nsummaryRanges.getIntervals(); // return [[1, 1], [3, 3]]\nsummaryRanges.addNum(7);      // arr = [1, 3, 7]\nsummaryRanges.getIntervals(); // return [[1, 1], [3, 3], [7, 7]]\nsummaryRanges.addNum(2);      // arr = [1, 2, 3, 7]\nsummaryRanges.getIntervals(); // return [[1, 3], [7, 7]]\nsummaryRanges.addNum(6);      // arr = [1, 2, 3, 6, 7]\nsummaryRanges.getIntervals(); // return [[1, 3], [6, 7]]"}]'::jsonb,
  '["0 <= value <= 10^4","At most 3 * 10^4 calls will be made to addNum and getIntervals","At most 10^2 calls will be made to getIntervals"]'::jsonb,
  '["Binary Search","Design","Ordered Set","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"class SummaryRanges {\n  constructor() {\n    // Your code here\n  }\n  \n  addNum(value) {\n    // Your code here\n  }\n  \n  getIntervals() {\n    // Your code here\n  }\n}","python":"class SummaryRanges:\n    def __init__(self):\n        # Your code here\n        pass\n    \n    def addNum(self, value: int) -> None:\n        # Your code here\n        pass\n    \n    def getIntervals(self) -> List[List[int]]:\n        # Your code here\n        pass","java":"class SummaryRanges {\n    public SummaryRanges() {\n        // Your code here\n    }\n    \n    public void addNum(int value) {\n        // Your code here\n    }\n    \n    public int[][] getIntervals() {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[''SummaryRanges'', ''addNum'', ''getIntervals'', ''addNum'', ''getIntervals'']","output":"[null, null, [[1, 1]], null, [[1, 1], [3, 3]]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a TreeMap or sorted set to store intervals.","When adding a number, check if it merges with existing intervals.","Handle edge cases where a number creates a new interval or extends existing ones."]'::jsonb,
  41.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'meeting-rooms-ii',
  'Meeting Rooms II',
  'meeting-rooms-ii',
  'medium',
  'Given an array of meeting time intervals `intervals` where `intervals[i] = [starti, endi]`, return the minimum number of conference rooms required.',
  '[{"input":"intervals = [[0,30],[5,10],[15,20]]","output":"2","explanation":"We need two meeting rooms:\nRoom 1: [0,30]\nRoom 2: [5,10], [15,20]"},{"input":"intervals = [[7,10],[2,4]]","output":"1"}]'::jsonb,
  '["1 <= intervals.length <= 10^4","0 <= starti < endi <= 10^6"]'::jsonb,
  '["Array","Two Pointers","Sorting","Heap","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function minMeetingRooms(intervals) {\n  // Your code here\n}","python":"def minMeetingRooms(intervals):\n    # Your code here\n    pass","java":"class Solution {\n    public int minMeetingRooms(int[][] intervals) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[0,30],[5,10],[15,20]]","output":"2"},{"input":"[[7,10],[2,4]]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Sort meetings by start time.","Use a min heap to track end times of ongoing meetings.","When a meeting starts, remove all meetings that have ended from the heap."]'::jsonb,
  48.9,
  '["Google","Amazon","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'my-calendar-ii',
  'My Calendar II',
  'my-calendar-ii',
  'medium',
  'You are implementing a program to use as your calendar. We can add a new event if adding the event will not cause a triple booking.

A triple booking happens when three events have some non-empty intersection (i.e., some moment is common to all the three events.).

The event can be represented as a pair of integers `start` and `end` that represents a booking on the half-open interval `[start, end)`, the range of real numbers `x` such that `start <= x < end`.

Implement the `MyCalendarTwo` class:

- `MyCalendarTwo()` Initializes the calendar object.
- `boolean book(int start, int end)` Returns `true` if the event can be added to the calendar successfully without causing a triple booking. Otherwise, return `false` and do not add the event to the calendar.',
  '[{"input":"[\"MyCalendarTwo\", \"book\", \"book\", \"book\", \"book\", \"book\", \"book\"]\n[[], [10, 20], [50, 60], [10, 40], [5, 15], [5, 10], [25, 55]]","output":"[null, true, true, true, false, true, true]","explanation":"MyCalendarTwo myCalendarTwo = new MyCalendarTwo();\nmyCalendarTwo.book(10, 20); // return True\nmyCalendarTwo.book(50, 60); // return True\nmyCalendarTwo.book(10, 40); // return True\nmyCalendarTwo.book(5, 15); // return False, causes triple booking\nmyCalendarTwo.book(5, 10); // return True\nmyCalendarTwo.book(25, 55); // return True"}]'::jsonb,
  '["0 <= start < end <= 10^9","At most 1000 calls will be made to book"]'::jsonb,
  '["Design","Segment Tree","Ordered Set","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"class MyCalendarTwo {\n  constructor() {\n    // Your code here\n  }\n  \n  book(start, end) {\n    // Your code here\n  }\n}","python":"class MyCalendarTwo:\n    def __init__(self):\n        # Your code here\n        pass\n    \n    def book(self, start: int, end: int) -> bool:\n        # Your code here\n        pass","java":"class MyCalendarTwo {\n    public MyCalendarTwo() {\n        // Your code here\n    }\n    \n    public boolean book(int start, int end) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[''MyCalendarTwo'', ''book'', ''book'', ''book'']","output":"[null, true, true, true]"}]'::jsonb,
  '[]'::jsonb,
  '["Keep track of single bookings and double bookings separately.","Before adding a new event, check if it overlaps with any double booking.","If it doesn''t cause a triple booking, add overlaps with single bookings to double bookings."]'::jsonb,
  55.3,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'meeting-rooms',
  'Meeting Rooms',
  'meeting-rooms',
  'easy',
  'Given an array of meeting time intervals `intervals` where `intervals[i] = [starti, endi]`, determine if a person could attend all meetings.',
  '[{"input":"intervals = [[0,30],[5,10],[15,20]]","output":"false","explanation":"The person cannot attend all meetings because [0,30] overlaps with [5,10] and [15,20]."},{"input":"intervals = [[7,10],[2,4]]","output":"true","explanation":"The person can attend all meetings as they don''t overlap."}]'::jsonb,
  '["0 <= intervals.length <= 10^4","intervals[i].length == 2","0 <= starti < endi <= 10^6"]'::jsonb,
  '["Array","Sorting","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function canAttendMeetings(intervals) {\n  // Your code here\n}","python":"def canAttendMeetings(intervals):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean canAttendMeetings(int[][] intervals) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[0,30],[5,10],[15,20]]","output":"false"},{"input":"[[7,10],[2,4]]","output":"true"}]'::jsonb,
  '[]'::jsonb,
  '["Sort the intervals by start time.","Check if any interval''s start time is before the previous interval''s end time.","If there''s any overlap, return false."]'::jsonb,
  54.2,
  '["Facebook","Amazon","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'my-calendar-i-brute',
  'My Calendar I (Brute Force + Line Sweep)',
  'my-calendar-i-brute',
  'medium',
  'You are implementing a program to use as your calendar. We can add a new event if adding the event will not cause a double booking.

A double booking happens when two events have some non-empty intersection (i.e., some moment is common to both events.).

The event can be represented as a pair of integers `start` and `end` that represents a booking on the half-open interval `[start, end)`, the range of real numbers `x` such that `start <= x < end`.

Implement the `MyCalendar` class:

- `MyCalendar()` Initializes the calendar object.
- `boolean book(int start, int end)` Returns `true` if the event can be added to the calendar successfully without causing a double booking. Otherwise, return `false` and do not add the event to the calendar.',
  '[{"input":"[\"MyCalendar\", \"book\", \"book\", \"book\"]\n[[], [10, 20], [15, 25], [20, 30]]","output":"[null, true, false, true]","explanation":"MyCalendar myCalendar = new MyCalendar();\nmyCalendar.book(10, 20); // return True\nmyCalendar.book(15, 25); // return False, causes double booking\nmyCalendar.book(20, 30); // return True"}]'::jsonb,
  '["0 <= start < end <= 10^9","At most 1000 calls will be made to book"]'::jsonb,
  '["Design","Segment Tree","Ordered Set","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"class MyCalendar {\n  constructor() {\n    // Your code here\n  }\n  \n  book(start, end) {\n    // Your code here\n  }\n}","python":"class MyCalendar:\n    def __init__(self):\n        # Your code here\n        pass\n    \n    def book(self, start: int, end: int) -> bool:\n        # Your code here\n        pass","java":"class MyCalendar {\n    public MyCalendar() {\n        // Your code here\n    }\n    \n    public boolean book(int start, int end) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[''MyCalendar'', ''book'', ''book'', ''book'']","output":"[null, true, false, true]"}]'::jsonb,
  '[]'::jsonb,
  '["Brute Force: Check every existing booking for overlap.","Line Sweep: Use a map to track start and end events.","An overlap exists if max(start1, start2) < min(end1, end2)."]'::jsonb,
  56.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'my-calendar-iii',
  '732. My Calendar III',
  'my-calendar-iii',
  'hard',
  'A k-booking happens when k events have some non-empty intersection (i.e., there is some time that is common to all k events.) You are given some events [start, end), after each given event, return an integer k representing the maximum k-booking between all the previous events. Implement the MyCalendarThree class: MyCalendarThree() Initializes the object. int book(int start, int end) Returns an integer representing the largest integer k such that there exists a k-booking in the calendar.',
  '[{"input":"[\"MyCalendarThree\", \"book\", \"book\", \"book\", \"book\", \"book\", \"book\"]\\n[[], [10, 20], [50, 60], [10, 40], [5, 15], [5, 10], [25, 55]]","output":"[null, 1, 1, 2, 3, 3, 3]"}]'::jsonb,
  '["0 <= start < end <= 10^9","At most 400 calls will be made to book"]'::jsonb,
  '["Design","Segment Tree","Binary Search","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"class MyCalendarThree {\n  constructor() {\n  }\n  book(start, end) {\n  }\n}","python":"class MyCalendarThree:\n    def __init__(self):\n        pass\n    def book(self, start, end):\n        pass","java":"class MyCalendarThree {\n    public MyCalendarThree() {\n    }\n    public int book(int start, int end) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MyCalendarThree\", \"book\", \"book\", \"book\", \"book\", \"book\", \"book\"], [[], [10, 20], [50, 60], [10, 40], [5, 15], [5, 10], [25, 55]]","expectedOutput":"[null, 1, 1, 2, 3, 3, 3]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use difference array with TreeMap","Track overlapping intervals count"]'::jsonb,
  70.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-linked-list',
  'Reverse Linked List',
  'reverse-linked-list',
  'easy',
  'Given the head of a singly linked list, reverse the list, and return the reversed list.',
  '[{"input":"head = [1,2,3,4,5]","output":"[5,4,3,2,1]"}]'::jsonb,
  '["The number of nodes in the list is in range [0, 5000]"]'::jsonb,
  '["Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseList(head) {\n  // Your code here\n}","python":"def reverse_list(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode reverseList(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5]","expectedOutput":"[5,4,3,2,1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use three pointers: prev, current, next","Iterate and reverse links one by one"]'::jsonb,
  72.1,
  '["Amazon","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-nodes-k-group',
  'Reverse Nodes in k-Group',
  'reverse-nodes-k-group',
  'hard',
  'Given the `head` of a linked list, reverse the nodes of the list `k` at a time, and return the modified list.

`k` is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of `k` then left-out nodes, in the end, should remain as it is.

You may not alter the values in the list''s nodes, only nodes themselves may be changed.',
  '[{"input":"head = [1,2,3,4,5], k = 2","output":"[2,1,4,3,5]"},{"input":"head = [1,2,3,4,5], k = 3","output":"[3,2,1,4,5]"}]'::jsonb,
  '["The number of nodes in the list is n","1 <= k <= n <= 5000","0 <= Node.val <= 1000"]'::jsonb,
  '["Linked List","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseKGroup(head, k) {\n  // Your code here\n}","python":"def reverseKGroup(head, k):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode reverseKGroup(ListNode head, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5], 2","output":"[2,1,4,3,5]"},{"input":"[1,2,3,4,5], 3","output":"[3,2,1,4,5]"}]'::jsonb,
  '[]'::jsonb,
  '["Count nodes to check if we have k nodes to reverse.","Reverse k nodes at a time and connect with previous group.","Use recursion to handle remaining nodes."]'::jsonb,
  57.8,
  '["Facebook","Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-linked-list-ii',
  'Reverse Linked List II',
  'reverse-linked-list-ii',
  'medium',
  'Given the `head` of a singly linked list and two integers `left` and `right` where `left <= right`, reverse the nodes of the list from position `left` to position `right`, and return the reversed list.',
  '[{"input":"head = [1,2,3,4,5], left = 2, right = 4","output":"[1,4,3,2,5]"},{"input":"head = [5], left = 1, right = 1","output":"[5]"}]'::jsonb,
  '["The number of nodes in the list is n","1 <= n <= 500","-500 <= Node.val <= 500","1 <= left <= right <= n"]'::jsonb,
  '["Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseBetween(head, left, right) {\n  // Your code here\n}","python":"def reverseBetween(head, left, right):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode reverseBetween(ListNode head, int left, int right) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5], 2, 4","output":"[1,4,3,2,5]"},{"input":"[5], 1, 1","output":"[5]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a dummy node to handle edge case where left = 1.","Navigate to the node before left position.","Reverse nodes from left to right, then reconnect."]'::jsonb,
  45.2,
  '["Facebook","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reorder-list',
  'Reorder List',
  'reorder-list',
  'medium',
  'You are given the head of a singly linked-list. The list can be represented as:

L0 → L1 → … → Ln - 1 → Ln

Reorder the list to be on the following form:

L0 → Ln → L1 → Ln - 1 → L2 → Ln - 2 → …

You may not modify the values in the list''s nodes. Only nodes themselves may be changed.',
  '[{"input":"head = [1,2,3,4]","output":"[1,4,2,3]"},{"input":"head = [1,2,3,4,5]","output":"[1,5,2,4,3]"}]'::jsonb,
  '["The number of nodes in the list is in the range [1, 5 * 10^4]","1 <= Node.val <= 1000"]'::jsonb,
  '["Linked List","Two Pointers","Stack","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function reorderList(head) {\n  // Your code here\n}","python":"def reorderList(head):\n    # Your code here\n    pass","java":"class Solution {\n    public void reorderList(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4]","output":"[1,4,2,3]"},{"input":"[1,2,3,4,5]","output":"[1,5,2,4,3]"}]'::jsonb,
  '[]'::jsonb,
  '["Find the middle of the list using slow and fast pointers.","Reverse the second half of the list.","Merge the two halves alternately."]'::jsonb,
  55.1,
  '["Facebook","Amazon","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'swapping-nodes-linked-list',
  'Swapping Nodes in a Linked List',
  'swapping-nodes-linked-list',
  'medium',
  'You are given the `head` of a linked list, and an integer `k`.

Return the head of the linked list after swapping the values of the `kth` node from the beginning and the `kth` node from the end (the list is 1-indexed).',
  '[{"input":"head = [1,2,3,4,5], k = 2","output":"[1,4,3,2,5]"},{"input":"head = [7,9,6,6,7,8,3,0,9,5], k = 5","output":"[7,9,6,6,8,7,3,0,9,5]"}]'::jsonb,
  '["The number of nodes in the list is n","1 <= k <= n <= 10^5","0 <= Node.val <= 100"]'::jsonb,
  '["Linked List","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function swapNodes(head, k) {\n  // Your code here\n}","python":"def swapNodes(head, k):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode swapNodes(ListNode head, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5], 2","output":"[1,4,3,2,5]"},{"input":"[7,9,6,6,7,8,3,0,9,5], 5","output":"[7,9,6,6,8,7,3,0,9,5]"}]'::jsonb,
  '[]'::jsonb,
  '["Find the kth node from the beginning.","Use two pointers to find the kth node from the end.","Swap the values of the two nodes."]'::jsonb,
  68.9,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-nodes-even-length',
  'Reverse Nodes in Even Length Groups',
  'reverse-nodes-even-length',
  'medium',
  'You are given the `head` of a linked list.

The nodes in the linked list are sequentially assigned to non-empty groups whose lengths form the sequence of the natural numbers (1, 2, 3, 4, ...). The length of a group is the number of nodes assigned to it. In other words,

- The 1st node is assigned to the first group.
- The 2nd and the 3rd nodes are assigned to the second group.
- The 4th, 5th, and 6th nodes are assigned to the third group, and so on.

Note that the length of the last group may be less than or equal to `1 + the length of the second to last group`.

Reverse the nodes in each group with an even length, and return the head of the modified linked list.',
  '[{"input":"head = [5,2,6,3,9,1,7,3,8,4]","output":"[5,6,2,3,9,1,4,8,3,7]","explanation":"- The length of the first group is 1, which is odd, so no reversal occurs.\n- The length of the second group is 2, which is even, so the nodes are reversed.\n- The length of the third group is 3, which is odd, so no reversal occurs.\n- The length of the last group is 4, which is even, so the nodes are reversed."}]'::jsonb,
  '["The number of nodes in the list is in the range [1, 10^5]","0 <= Node.val <= 10^5"]'::jsonb,
  '["Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseEvenLengthGroups(head) {\n  // Your code here\n}","python":"def reverseEvenLengthGroups(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode reverseEvenLengthGroups(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[5,2,6,3,9,1,7,3,8,4]","output":"[5,6,2,3,9,1,4,8,3,7]"},{"input":"[1,1,0,6]","output":"[1,0,1,6]"}]'::jsonb,
  '[]'::jsonb,
  '["Process groups of increasing size: 1, 2, 3, 4, etc.","For each group, count its actual length.","Reverse the group only if its length is even."]'::jsonb,
  54.7,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-duplicates-sorted-list',
  'Remove Duplicates from Sorted List',
  'remove-duplicates-sorted-list',
  'easy',
  'Given the `head` of a sorted linked list, delete all duplicates such that each element appears only once. Return the linked list sorted as well.',
  '[{"input":"head = [1,1,2]","output":"[1,2]"},{"input":"head = [1,1,2,3,3]","output":"[1,2,3]"}]'::jsonb,
  '["The number of nodes in the list is in the range [0, 300]","-100 <= Node.val <= 100","The list is guaranteed to be sorted in ascending order"]'::jsonb,
  '["Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"function deleteDuplicates(head) {\n  // Your code here\n}","python":"def deleteDuplicates(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode deleteDuplicates(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,1,2]","output":"[1,2]"},{"input":"[1,1,2,3,3]","output":"[1,2,3]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a single pointer to traverse the list.","If current node''s value equals next node''s value, skip the next node.","Otherwise, move to the next node."]'::jsonb,
  52.3,
  '["Amazon","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-linked-list-elements',
  'Remove Linked List Elements',
  'remove-linked-list-elements',
  'easy',
  'Given the `head` of a linked list and an integer `val`, remove all the nodes of the linked list that has `Node.val == val`, and return the new head.',
  '[{"input":"head = [1,2,6,3,4,5,6], val = 6","output":"[1,2,3,4,5]"},{"input":"head = [], val = 1","output":"[]"},{"input":"head = [7,7,7,7], val = 7","output":"[]"}]'::jsonb,
  '["The number of nodes in the list is in the range [0, 10^4]","1 <= Node.val <= 50","0 <= val <= 50"]'::jsonb,
  '["Linked List","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function removeElements(head, val) {\n  // Your code here\n}","python":"def removeElements(head, val):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode removeElements(ListNode head, int val) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,6,3,4,5,6], 6","output":"[1,2,3,4,5]"},{"input":"[], 1","output":"[]"},{"input":"[7,7,7,7], 7","output":"[]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a dummy node to handle edge cases where head needs to be removed.","Traverse the list and skip nodes with the target value.","Can also be solved recursively."]'::jsonb,
  45.8,
  '["Amazon","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'split-linked-list-parts',
  'Split Linked List in Parts',
  'split-linked-list-parts',
  'medium',
  'Given the `head` of a singly linked list and an integer `k`, split the linked list into `k` consecutive linked list parts.

The length of each part should be as equal as possible: no two parts should have a size differing by more than one. This may lead to some parts being null.

The parts should be in the order of occurrence in the input list, and parts occurring earlier should always have a size greater than or equal to parts occurring later.

Return an array of the `k` parts.',
  '[{"input":"head = [1,2,3], k = 5","output":"[[1],[2],[3],[],[]]","explanation":"The first element output[0] has output[0].val = 1, output[0].next = null.\nThe last element output[4] is null, but its string representation as a ListNode is []."},{"input":"head = [1,2,3,4,5,6,7,8,9,10], k = 3","output":"[[1,2,3,4],[5,6,7],[8,9,10]]","explanation":"The input has been split into consecutive parts with size difference at most 1, and earlier parts are a larger size than the later parts."}]'::jsonb,
  '["The number of nodes in the list is in the range [0, 1000]","0 <= Node.val <= 1000","1 <= k <= 50"]'::jsonb,
  '["Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"function splitListToParts(head, k) {\n  // Your code here\n}","python":"def splitListToParts(head, k):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode[] splitListToParts(ListNode head, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3], 5","output":"[[1],[2],[3],[],[]]"},{"input":"[1,2,3,4,5,6,7,8,9,10], 3","output":"[[1,2,3,4],[5,6,7],[8,9,10]]"}]'::jsonb,
  '[]'::jsonb,
  '["First, count the total number of nodes.","Calculate the base size of each part and how many parts need an extra node.","Split the list accordingly, breaking the links at appropriate points."]'::jsonb,
  58.4,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'odd-even-linked-list',
  'Odd Even Linked List',
  'odd-even-linked-list',
  'medium',
  'Given the `head` of a singly linked list, group all the nodes with odd indices together followed by the nodes with even indices, and return the reordered list.

The first node is considered odd, and the second node is even, and so on.

Note that the relative order inside both the even and odd groups should remain as it was in the input.

You must solve the problem in O(1) extra space complexity and O(n) time complexity.',
  '[{"input":"head = [1,2,3,4,5]","output":"[1,3,5,2,4]"},{"input":"head = [2,1,3,5,6,4,7]","output":"[2,3,6,7,1,5,4]"}]'::jsonb,
  '["The number of nodes in the linked list is in the range [0, 10^4]","-10^6 <= Node.val <= 10^6"]'::jsonb,
  '["Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"function oddEvenList(head) {\n  // Your code here\n}","python":"def oddEvenList(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode oddEvenList(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5]","output":"[1,3,5,2,4]"},{"input":"[2,1,3,5,6,4,7]","output":"[2,3,6,7,1,5,4]"}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers: one for odd nodes and one for even nodes.","Link odd nodes together and even nodes together.","Connect the end of odd list to the head of even list."]'::jsonb,
  61.2,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'swap-nodes-pairs',
  'Swap Nodes in Pairs',
  'swap-nodes-pairs',
  'medium',
  'Given a linked list, swap every two adjacent nodes and return its head. You must solve the problem without modifying the values in the list''s nodes (i.e., only nodes themselves may be changed.)',
  '[{"input":"head = [1,2,3,4]","output":"[2,1,4,3]"},{"input":"head = []","output":"[]"},{"input":"head = [1]","output":"[1]"}]'::jsonb,
  '["The number of nodes in the list is in the range [0, 100]","0 <= Node.val <= 100"]'::jsonb,
  '["Linked List","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function swapPairs(head) {\n  // Your code here\n}","python":"def swapPairs(head):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode swapPairs(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4]","output":"[2,1,4,3]"},{"input":"[]","output":"[]"},{"input":"[1]","output":"[1]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a dummy node to simplify edge cases.","For each pair, adjust the pointers to swap them.","Can also be solved recursively by swapping current pair and recursing on rest."]'::jsonb,
  61.7,
  '["Amazon","Microsoft","Bloomberg","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'ipo',
  'IPO',
  'ipo',
  'hard',
  'Suppose LeetCode will start its IPO soon. In order to sell a good price of its shares to Venture Capital, LeetCode would like to work on some projects to increase its capital before the IPO. Since it has limited resources, it can only finish at most `k` distinct projects before the IPO. Help LeetCode design the best way to maximize its total capital after finishing at most `k` distinct projects.

You are given `n` projects where the `ith` project has a pure profit `profits[i]` and a minimum capital of `capital[i]` is needed to start it.

Initially, you have `w` capital. When you finish a project, you will obtain its pure profit and the profit will be added to your total capital.

Pick a list of at most `k` distinct projects from given projects to maximize your final capital, and return the final maximized capital.

The answer is guaranteed to fit in a 32-bit signed integer.',
  '[{"input":"k = 2, w = 0, profits = [1,2,3], capital = [0,1,1]","output":"4","explanation":"Since your initial capital is 0, you can only start the project indexed 0.\nAfter finishing it you will obtain profit 1 and your capital becomes 1.\nWith capital 1, you can either start the project indexed 1 or the project indexed 2.\nSince you can choose at most 2 projects, you need to finish the project indexed 2 to get the maximum capital.\nTherefore, output the final maximized capital, which is 0 + 1 + 3 = 4."},{"input":"k = 3, w = 0, profits = [1,2,3], capital = [0,1,2]","output":"6"}]'::jsonb,
  '["1 <= k <= 10^5","0 <= w <= 10^9","n == profits.length","n == capital.length","1 <= n <= 10^5","0 <= profits[i] <= 10^4","0 <= capital[i] <= 10^9"]'::jsonb,
  '["Array","Greedy","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function findMaximizedCapital(k, w, profits, capital) {\n  // Your code here\n}","python":"def findMaximizedCapital(k, w, profits, capital):\n    # Your code here\n    pass","java":"class Solution {\n    public int findMaximizedCapital(int k, int w, int[] profits, int[] capital) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"2, 0, [1,2,3], [0,1,1]","output":"4"},{"input":"3, 0, [1,2,3], [0,1,2]","output":"6"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap for available projects sorted by capital requirement.","Use a max heap for projects we can afford, sorted by profit.","Repeatedly pick the most profitable project we can afford."]'::jsonb,
  46.2,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-median-data-stream',
  'Find Median from Data Stream',
  'find-median-data-stream',
  'hard',
  'The median is the middle value in an ordered integer list. If the size of the list is even, there is no middle value, and the median is the mean of the two middle values.

Implement the MedianFinder class:

- `MedianFinder()` initializes the `MedianFinder` object.
- `void addNum(int num)` adds the integer `num` from the data stream to the data structure.
- `double findMedian()` returns the median of all elements so far. Answers within `10^-5` of the actual answer will be accepted.',
  '[{"input":"[\"MedianFinder\", \"addNum\", \"addNum\", \"findMedian\", \"addNum\", \"findMedian\"]\n[[], [1], [2], [], [3], []]","output":"[null, null, null, 1.5, null, 2.0]","explanation":"MedianFinder medianFinder = new MedianFinder();\nmedianFinder.addNum(1);    // arr = [1]\nmedianFinder.addNum(2);    // arr = [1, 2]\nmedianFinder.findMedian(); // return 1.5 (i.e., (1 + 2) / 2)\nmedianFinder.addNum(3);    // arr[1, 2, 3]\nmedianFinder.findMedian(); // return 2.0"}]'::jsonb,
  '["-10^5 <= num <= 10^5","There will be at least one element in the data structure before calling findMedian","At most 5 * 10^4 calls will be made to addNum and findMedian"]'::jsonb,
  '["Two Pointers","Design","Sorting","Heap","Data Stream"]'::jsonb,
  'DSA',
  '{"javascript":"class MedianFinder {\n  constructor() {\n    // Your code here\n  }\n  \n  addNum(num) {\n    // Your code here\n  }\n  \n  findMedian() {\n    // Your code here\n  }\n}","python":"class MedianFinder:\n    def __init__(self):\n        # Your code here\n        pass\n    \n    def addNum(self, num: int) -> None:\n        # Your code here\n        pass\n    \n    def findMedian(self) -> float:\n        # Your code here\n        pass","java":"class MedianFinder {\n    public MedianFinder() {\n        // Your code here\n    }\n    \n    public void addNum(int num) {\n        // Your code here\n    }\n    \n    public double findMedian() {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[''MedianFinder'', ''addNum'', ''addNum'', ''findMedian'', ''addNum'', ''findMedian'']","output":"[null, null, null, 1.5, null, 2.0]"}]'::jsonb,
  '[]'::jsonb,
  '["Use two heaps: a max heap for the smaller half and a min heap for the larger half.","Keep heaps balanced so their sizes differ by at most 1.","Median is either the top of one heap or average of both tops."]'::jsonb,
  51.8,
  '["Google","Amazon","Facebook","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sliding-window-median',
  'Sliding Window Median',
  'sliding-window-median',
  'hard',
  'The median is the middle value in an ordered integer list. If the size of the list is even, there is no middle value. So the median is the mean of the two middle values.

You are given an integer array `nums` and an integer `k`. There is a sliding window of size `k` which is moving from the very left of the array to the very right. You can only see the `k` numbers in the window. Each time the sliding window moves right by one position.

Return the median array for each window in the original array. Answers within `10^-5` of the actual value will be accepted.',
  '[{"input":"nums = [1,3,-1,-3,5,3,6,7], k = 3","output":"[1.00000,-1.00000,-1.00000,3.00000,5.00000,6.00000]","explanation":"Window position                Median\n---------------                -----\n[1  3  -1] -3  5  3  6  7        1\n 1 [3  -1  -3] 5  3  6  7       -1\n 1  3 [-1  -3  5] 3  6  7       -1\n 1  3  -1 [-3  5  3] 6  7        3\n 1  3  -1  -3 [5  3  6] 7        5\n 1  3  -1  -3  5 [3  6  7]       6"}]'::jsonb,
  '["1 <= k <= nums.length <= 10^5","-2^31 <= nums[i] <= 2^31 - 1"]'::jsonb,
  '["Array","Hash Table","Sliding Window","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function medianSlidingWindow(nums, k) {\n  // Your code here\n}","python":"def medianSlidingWindow(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public double[] medianSlidingWindow(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,3,-1,-3,5,3,6,7], 3","output":"[1.00000,-1.00000,-1.00000,3.00000,5.00000,6.00000]"},{"input":"[1,2,3,4,2,3,1,4,2], 3","output":"[2.00000,3.00000,3.00000,3.00000,2.00000,3.00000,2.00000]"}]'::jsonb,
  '[]'::jsonb,
  '["Extend the Find Median from Data Stream problem to handle removals.","Use two heaps with lazy deletion or a multiset.","Track elements to remove and handle them when they reach heap tops."]'::jsonb,
  41.3,
  '["Google","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'task-scheduler',
  'Task Scheduler',
  'task-scheduler',
  'medium',
  'Given a characters array `tasks`, representing the tasks a CPU needs to do, where each letter represents a different task. Tasks could be done in any order. Each task is done in one unit of time. For each unit of time, the CPU could complete either one task or just be idle.

However, there is a non-negative integer `n` that represents the cooldown period between two same tasks (the same letter in the array), that is that there must be at least `n` units of time between any two same tasks.

Return the least number of units of times that the CPU will take to finish all the given tasks.',
  '[{"input":"tasks = [\"A\",\"A\",\"A\",\"B\",\"B\",\"B\"], n = 2","output":"8","explanation":"A -> B -> idle -> A -> B -> idle -> A -> B\nThere is at least 2 units of time between any two same tasks."},{"input":"tasks = [\"A\",\"A\",\"A\",\"B\",\"B\",\"B\"], n = 0","output":"6","explanation":"On this case any permutation of size 6 would work since n = 0.\n[\"A\",\"A\",\"A\",\"B\",\"B\",\"B\"]\n[\"A\",\"B\",\"A\",\"B\",\"A\",\"B\"]\n[\"B\",\"B\",\"B\",\"A\",\"A\",\"A\"]\n...\nAnd so on."}]'::jsonb,
  '["1 <= task.length <= 10^4","tasks[i] is upper-case English letter","The integer n is in the range [0, 100]"]'::jsonb,
  '["Array","Hash Table","Greedy","Sorting","Heap","Counting"]'::jsonb,
  'DSA',
  '{"javascript":"function leastInterval(tasks, n) {\n  // Your code here\n}","python":"def leastInterval(tasks, n):\n    # Your code here\n    pass","java":"class Solution {\n    public int leastInterval(char[] tasks, int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[\"A\",\"A\",\"A\",\"B\",\"B\",\"B\"], 2","output":"8"},{"input":"[\"A\",\"A\",\"A\",\"B\",\"B\",\"B\"], 0","output":"6"}]'::jsonb,
  '[]'::jsonb,
  '["Count frequency of each task.","Use a max heap to always schedule the most frequent available task.","Track cooldowns for tasks and add them back when ready."]'::jsonb,
  57.4,
  '["Amazon","Facebook","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'meeting-rooms-iii',
  'Meeting Rooms III',
  'meeting-rooms-iii',
  'hard',
  'You are given an integer `n`. There are `n` rooms numbered from `0` to `n - 1`.

You are given a 2D integer array `meetings` where `meetings[i] = [starti, endi]` means that a meeting will be held during the half-closed time interval `[starti, endi)`. All the values of `starti` are unique.

Meetings are allocated to rooms in the following manner:

1. Each meeting will take place in the unused room with the lowest number.
2. If there are no available rooms, the meeting will be delayed until a room becomes free. The delayed meeting should have the same duration as the original meeting.
3. When a room becomes unused, meetings that have an earlier original start time should be given the room.

Return the number of the room that held the most meetings. If there are multiple rooms, return the room with the lowest number.

A half-closed interval `[a, b)` is the interval between `a` and `b` including `a` and not including `b`.',
  '[{"input":"n = 2, meetings = [[0,10],[1,5],[2,7],[3,4]]","output":"0","explanation":"- At time 0, both rooms are not being used. The first meeting starts in room 0.\n- At time 1, only room 1 is not being used. The second meeting starts in room 1.\n- At time 2, both rooms are being used. The third meeting is delayed.\n- At time 3, both rooms are being used. The fourth meeting is delayed.\n- At time 5, the meeting in room 1 finishes. The third meeting starts in room 1 for the time period [5,10).\n- At time 10, the meetings in both rooms finish. The fourth meeting starts in room 0 for the time period [10,11).\nBoth rooms 0 and 1 held 2 meetings, so we return 0."}]'::jsonb,
  '["1 <= n <= 100","1 <= meetings.length <= 10^5","meetings[i].length == 2","0 <= starti < endi <= 5 * 10^5","All the values of starti are unique"]'::jsonb,
  '["Array","Hash Table","Sorting","Heap","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function mostBooked(n, meetings) {\n  // Your code here\n}","python":"def mostBooked(n, meetings):\n    # Your code here\n    pass","java":"class Solution {\n    public int mostBooked(int n, int[][] meetings) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"2, [[0,10],[1,5],[2,7],[3,4]]","output":"0"},{"input":"3, [[1,20],[2,10],[3,5],[4,9],[6,8]]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Sort meetings by start time.","Use a min heap for available rooms.","Use another min heap for occupied rooms sorted by end time.","Track meeting count for each room."]'::jsonb,
  42.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'largest-number-after-digit-swaps',
  'Largest Number After Digit Swaps by Parity',
  'largest-number-after-digit-swaps',
  'easy',
  'You are given a positive integer `num`. You may swap any two digits of `num` that have the same parity (i.e. both odd digits or both even digits).

Return the largest possible value of `num` after any number of swaps.',
  '[{"input":"num = 1234","output":"3412","explanation":"Swap the digit 3 with the digit 1, this results in the number 3214.\nSwap the digit 2 with the digit 4, this results in the number 3412.\nNote that there may be other sequences of swaps but it can be shown that 3412 is the largest possible number."},{"input":"num = 65875","output":"87655","explanation":"Swap the digit 8 with the digit 6, this results in the number 85675.\nSwap the first digit 5 with the digit 7, this results in the number 87655.\nNote that there may be other sequences of swaps but it can be shown that 87655 is the largest possible number."}]'::jsonb,
  '["1 <= num <= 10^9"]'::jsonb,
  '["Math","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function largestInteger(num) {\n  // Your code here\n}","python":"def largestInteger(num):\n    # Your code here\n    pass","java":"class Solution {\n    public int largestInteger(int num) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"1234","output":"3412"},{"input":"65875","output":"87655"}]'::jsonb,
  '[]'::jsonb,
  '["Separate odd and even digits into two arrays.","Sort both arrays in descending order.","Place digits back in original positions maintaining parity."]'::jsonb,
  62.3,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-right-interval',
  'Find Right Interval',
  'find-right-interval',
  'medium',
  'You are given an array of `intervals`, where `intervals[i] = [starti, endi]` and each `starti` is unique.

The right interval for an interval `i` is an interval `j` such that `startj >= endi` and `startj` is minimized. Note that `i` may equal `j`.

Return an array of right interval indices for each interval `i`. If no right interval exists for interval `i`, then put `-1` at index `i`.',
  '[{"input":"intervals = [[1,2]]","output":"[-1]","explanation":"There is only one interval in the collection, so it outputs -1."},{"input":"intervals = [[3,4],[2,3],[1,2]]","output":"[-1,0,1]","explanation":"There is no right interval for [3,4].\nThe right interval for [2,3] is [3,4] since start0 = 3 is the smallest start that is >= end1 = 3.\nThe right interval for [1,2] is [2,3] since start1 = 2 is the smallest start that is >= end2 = 2."}]'::jsonb,
  '["1 <= intervals.length <= 2 * 10^4","intervals[i].length == 2","-10^6 <= starti <= endi <= 10^6","The start point of each interval is unique"]'::jsonb,
  '["Array","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function findRightInterval(intervals) {\n  // Your code here\n}","python":"def findRightInterval(intervals):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] findRightInterval(int[][] intervals) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,2]]","output":"[-1]"},{"input":"[[3,4],[2,3],[1,2]]","output":"[-1,0,1]"}]'::jsonb,
  '[]'::jsonb,
  '["Create a map of start values to their original indices.","Sort intervals by start value.","For each interval, use binary search to find the smallest start >= its end."]'::jsonb,
  50.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-happy-string',
  'Longest Happy String',
  'longest-happy-string',
  'medium',
  'A string `s` is called happy if it satisfies the following conditions:

- `s` only contains the letters `''a''`, `''b''`, and `''c''`.
- `s` does not contain any of `"aaa"`, `"bbb"`, or `"ccc"` as a substring.
- `s` contains at most `a` occurrences of the letter `''a''`.
- `s` contains at most `b` occurrences of the letter `''b''`.
- `s` contains at most `c` occurrences of the letter `''c''`.

Given three integers `a`, `b`, and `c`, return the longest possible happy string. If there are multiple longest happy strings, return any of them. If there is no such string, return the empty string `""`.

A substring is a contiguous sequence of characters within a string.',
  '[{"input":"a = 1, b = 1, c = 7","output":"\"ccaccbcc\"","explanation":"\"ccbccacc\" would also be a correct answer."},{"input":"a = 7, b = 1, c = 0","output":"\"aabaa\"","explanation":"It is the only correct answer in this case."}]'::jsonb,
  '["0 <= a, b, c <= 100","a + b + c > 0"]'::jsonb,
  '["String","Greedy","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function longestDiverseString(a, b, c) {\n  // Your code here\n}","python":"def longestDiverseString(a, b, c):\n    # Your code here\n    pass","java":"class Solution {\n    public String longestDiverseString(int a, int b, int c) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"1, 1, 7","output":"\"ccaccbcc\""},{"input":"7, 1, 0","output":"\"aabaa\""}]'::jsonb,
  '[]'::jsonb,
  '["Use a max heap to always pick the character with most remaining count.","Add 2 of that character if possible, otherwise 1.","If adding would create 3 in a row, pick the second most frequent character."]'::jsonb,
  58.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-average-pass-ratio',
  'Maximum Average Pass Ratio',
  'maximum-average-pass-ratio',
  'medium',
  'There is a school that has classes of students and each class will be having a final exam. You are given a 2D integer array `classes`, where `classes[i] = [passi, totali]`. You know beforehand that in the `ith` class, there are `totali` total students, but only `passi` number of students will pass the exam.

You are also given an integer `extraStudents`. There are another `extraStudents` brilliant students that are guaranteed to pass the exam of any class they are assigned to. You want to assign each of the `extraStudents` students to a class in a way that maximizes the average pass ratio across all the classes.

The pass ratio of a class is equal to the number of students of the class that will pass the exam divided by the total number of students of the class. The average pass ratio is the sum of pass ratios of all the classes divided by the number of the classes.

Return the maximum possible average pass ratio after assigning the `extraStudents` students. Answers within `10^-5` of the actual answer will be accepted.',
  '[{"input":"classes = [[1,2],[3,5],[2,2]], extraStudents = 2","output":"0.78333","explanation":"You can assign the two extra students to the first class. The average pass ratio will be equal to (3/4 + 3/5 + 2/2) / 3 = 0.78333."},{"input":"classes = [[2,4],[3,9],[4,5],[2,10]], extraStudents = 4","output":"0.53485"}]'::jsonb,
  '["1 <= classes.length <= 10^5","classes[i].length == 2","1 <= passi <= totali <= 10^5","1 <= extraStudents <= 10^5"]'::jsonb,
  '["Array","Greedy","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function maxAverageRatio(classes, extraStudents) {\n  // Your code here\n}","python":"def maxAverageRatio(classes, extraStudents):\n    # Your code here\n    pass","java":"class Solution {\n    public double maxAverageRatio(int[][] classes, int extraStudents) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,2],[3,5],[2,2]], 2","output":"0.78333"},{"input":"[[2,4],[3,9],[4,5],[2,10]], 4","output":"0.53485"}]'::jsonb,
  '[]'::jsonb,
  '["Use a max heap based on the gain in pass ratio from adding one student.","The gain is (pass+1)/(total+1) - pass/total.","Repeatedly add student to class with maximum gain."]'::jsonb,
  54.9,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'smallest-unoccupied-chair',
  'The Number of the Smallest Unoccupied Chair',
  'smallest-unoccupied-chair',
  'medium',
  'There is a party where `n` friends numbered from `0` to `n - 1` are attending. There is an infinite number of chairs in this party that are numbered from `0` to `infinity`. When a friend arrives at the party, they sit on the unoccupied chair with the smallest number.

For example, if chairs `0`, `1`, and `5` are occupied when a friend comes, they will sit on chair number `2`.

When a friend leaves the party, their chair becomes unoccupied at the moment they leave. If another friend arrives at that same moment, they can sit in that chair.

You are given a 0-indexed 2D integer array `times` where `times[i] = [arrivali, leavingi]`, indicating the arrival and leaving times of the `ith` friend respectively, and an integer `targetFriend`. All arrival times are distinct.

Return the chair number that the friend numbered `targetFriend` will sit on.',
  '[{"input":"times = [[1,4],[2,3],[4,6]], targetFriend = 1","output":"1","explanation":"- Friend 0 arrives at time 1 and sits on chair 0.\n- Friend 1 arrives at time 2 and sits on chair 1.\n- Friend 1 leaves at time 3 and chair 1 becomes empty.\n- Friend 0 leaves at time 4 and chair 0 becomes empty.\n- Friend 2 arrives at time 4 and sits on chair 0.\nSince friend 1 sat on chair 1, we return 1."},{"input":"times = [[3,10],[1,5],[2,6]], targetFriend = 0","output":"2","explanation":"- Friend 1 arrives at time 1 and sits on chair 0.\n- Friend 2 arrives at time 2 and sits on chair 1.\n- Friend 0 arrives at time 3 and sits on chair 2.\n- Friend 1 leaves at time 5 and chair 0 becomes empty.\n- Friend 2 leaves at time 6 and chair 1 becomes empty.\n- Friend 0 leaves at time 10 and chair 2 becomes empty.\nSince friend 0 sat on chair 2, we return 2."}]'::jsonb,
  '["n == times.length","2 <= n <= 10^4","times[i].length == 2","1 <= arrivali < leavingi <= 10^5","0 <= targetFriend <= n - 1","Each arrivali time is distinct"]'::jsonb,
  '["Array","Hash Table","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function smallestChair(times, targetFriend) {\n  // Your code here\n}","python":"def smallestChair(times, targetFriend):\n    # Your code here\n    pass","java":"class Solution {\n    public int smallestChair(int[][] times, int targetFriend) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,4],[2,3],[4,6]], 1","output":"1"},{"input":"[[3,10],[1,5],[2,6]], 0","output":"2"}]'::jsonb,
  '[]'::jsonb,
  '["Sort friends by arrival time, keeping track of original indices.","Use a min heap for available chairs.","Use another min heap for occupied chairs sorted by leaving time.","When processing arrival, free chairs that should be freed."]'::jsonb,
  44.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'construct-target-array',
  'Construct Target Array With Multiple Sums',
  'construct-target-array',
  'hard',
  'You are given an array `target` of n integers. From a starting array `arr` consisting of `n` 1''s, you may perform the following procedure:

- let `x` be the sum of all elements currently in your array.
- choose index `i`, such that `0 <= i < n` and set the value of `arr` at index `i` to `x`.
- You may repeat this procedure as many times as needed.

Return `true` if it is possible to construct the `target` array from `arr`, otherwise, return `false`.',
  '[{"input":"target = [9,3,5]","output":"true","explanation":"Start with arr = [1, 1, 1]\n[1, 1, 1], sum = 3 choose index 1\n[1, 3, 1], sum = 5 choose index 2\n[1, 3, 5], sum = 9 choose index 0\n[9, 3, 5] Done"},{"input":"target = [1,1,1,2]","output":"false","explanation":"Impossible to create target array from [1,1,1,1]."}]'::jsonb,
  '["n == target.length","1 <= n <= 5 * 10^4","1 <= target[i] <= 10^9"]'::jsonb,
  '["Array","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function isPossible(target) {\n  // Your code here\n}","python":"def isPossible(target):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean isPossible(int[] target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[9,3,5]","output":"true"},{"input":"[1,1,1,2]","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Work backwards from target to [1,1,...,1].","Use a max heap to always process the largest element.","The largest element was created from sum of all others plus its previous value.","Replace largest with: largest - (sum - largest)."]'::jsonb,
  38.4,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'kth-smallest-sum-matrix',
  'Find the Kth Smallest Sum of a Matrix With Sorted Rows',
  'kth-smallest-sum-matrix',
  'hard',
  'You are given an `m x n` matrix `mat` that has its rows sorted in non-decreasing order and an integer `k`.

You are allowed to choose exactly one element from each row to form an array.

Return the `kth` smallest array sum among all possible arrays.',
  '[{"input":"mat = [[1,3,11],[2,4,6]], k = 5","output":"7","explanation":"Choosing one element from each row, the first k smallest sum are:\n[1,2], [1,4], [3,2], [3,4], [1,6]. Where the 5th sum is 7."},{"input":"mat = [[1,3,11],[2,4,6]], k = 9","output":"17"},{"input":"mat = [[1,10,10],[1,4,5],[2,3,6]], k = 7","output":"9","explanation":"Choosing one element from each row, the first k smallest sum are:\n[1,1,2], [1,1,3], [1,4,2], [1,4,3], [1,1,6], [1,5,2], [1,5,3]. Where the 7th sum is 9."}]'::jsonb,
  '["m == mat.length","n == mat.length[i]","1 <= m, n <= 40","1 <= mat[i][j] <= 5000","1 <= k <= min(200, n^m)","mat[i] is a non-decreasing array"]'::jsonb,
  '["Array","Binary Search","Matrix","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function kthSmallest(mat, k) {\n  // Your code here\n}","python":"def kthSmallest(mat, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int kthSmallest(int[][] mat, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,3,11],[2,4,6]], 5","output":"7"},{"input":"[[1,3,11],[2,4,6]], 9","output":"17"},{"input":"[[1,10,10],[1,4,5],[2,3,6]], 7","output":"9"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap to track the k smallest sums.","Start with sum of first elements from each row.","For each sum, try adding next element from each row and push to heap.","Use a set to avoid duplicates."]'::jsonb,
  61.4,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-k-pairs-smallest-sums',
  'Find K Pairs with Smallest Sums',
  'find-k-pairs-smallest-sums',
  'medium',
  'You are given two integer arrays `nums1` and `nums2` sorted in non-decreasing order and an integer `k`.

Define a pair `(u, v)` which consists of one element from the first array and one element from the second array.

Return the `k` pairs `(u1, v1), (u2, v2), ..., (uk, vk)` with the smallest sums.',
  '[{"input":"nums1 = [1,7,11], nums2 = [2,4,6], k = 3","output":"[[1,2],[1,4],[1,6]]","explanation":"The first 3 pairs are returned from the sequence: [1,2],[1,4],[1,6],[7,2],[7,4],[11,2],[7,6],[11,4],[11,6]"},{"input":"nums1 = [1,1,2], nums2 = [1,2,3], k = 2","output":"[[1,1],[1,1]]","explanation":"The first 2 pairs are returned from the sequence: [1,1],[1,1],[1,2],[2,1],[1,2],[2,2],[1,3],[1,3],[2,3]"}]'::jsonb,
  '["1 <= nums1.length, nums2.length <= 10^5","-10^9 <= nums1[i], nums2[i] <= 10^9","nums1 and nums2 both are sorted in non-decreasing order","1 <= k <= 10^4","k <= nums1.length * nums2.length"]'::jsonb,
  '["Array","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function kSmallestPairs(nums1, nums2, k) {\n  // Your code here\n}","python":"def kSmallestPairs(nums1, nums2, k):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> kSmallestPairs(int[] nums1, int[] nums2, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,7,11], [2,4,6], 3","output":"[[1,2],[1,4],[1,6]]"},{"input":"[1,1,2], [1,2,3], 2","output":"[[1,1],[1,1]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap to track pairs with smallest sums.","Start with pairs (nums1[i], nums2[0]) for all i.","When popping (i, j), push (i, j+1) if it exists.","This ensures we explore pairs in order of increasing sum."]'::jsonb,
  40.2,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'merge-k-sorted-lists',
  'Merge k Sorted Lists',
  'merge-k-sorted-lists',
  'hard',
  'You are given an array of `k` linked-lists `lists`, each linked-list is sorted in ascending order.

Merge all the linked-lists into one sorted linked-list and return it.',
  '[{"input":"lists = [[1,4,5],[1,3,4],[2,6]]","output":"[1,1,2,3,4,4,5,6]","explanation":"The linked-lists are:\n[\n  1->4->5,\n  1->3->4,\n  2->6\n]\nmerging them into one sorted list:\n1->1->2->3->4->4->5->6"},{"input":"lists = []","output":"[]"},{"input":"lists = [[]]","output":"[]"}]'::jsonb,
  '["k == lists.length","0 <= k <= 10^4","0 <= lists[i].length <= 500","-10^4 <= lists[i][j] <= 10^4","lists[i] is sorted in ascending order","The sum of lists[i].length will not exceed 10^4"]'::jsonb,
  '["Linked List","Divide and Conquer","Heap","Merge Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function mergeKLists(lists) {\n  // Your code here\n}","python":"def mergeKLists(lists):\n    # Your code here\n    pass","java":"class Solution {\n    public ListNode mergeKLists(ListNode[] lists) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,4,5],[1,3,4],[2,6]]","output":"[1,1,2,3,4,4,5,6]"},{"input":"[]","output":"[]"},{"input":"[[]]","output":"[]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap to track the smallest node from each list.","Always extract minimum and add its next node to heap.","Alternative: Use divide and conquer to merge pairs of lists."]'::jsonb,
  51.3,
  '["Amazon","Facebook","Google","Microsoft","LinkedIn"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'kth-smallest-sorted-matrix',
  'Kth Smallest Element in a Sorted Matrix',
  'kth-smallest-sorted-matrix',
  'medium',
  'Given an `n x n` matrix where each of the rows and columns is sorted in ascending order, return the `kth` smallest element in the matrix.

Note that it is the `kth` smallest element in the sorted order, not the `kth` distinct element.

You must find a solution with a memory complexity better than O(n^2).',
  '[{"input":"matrix = [[1,5,9],[10,11,13],[12,13,15]], k = 8","output":"13","explanation":"The elements in the matrix are [1,5,9,10,11,12,13,13,15], and the 8th smallest number is 13"},{"input":"matrix = [[-5]], k = 1","output":"-5"}]'::jsonb,
  '["n == matrix.length == matrix[i].length","1 <= n <= 300","-10^9 <= matrix[i][j] <= 10^9","All the rows and columns of matrix are guaranteed to be sorted in non-decreasing order","1 <= k <= n^2"]'::jsonb,
  '["Array","Binary Search","Sorting","Heap","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function kthSmallest(matrix, k) {\n  // Your code here\n}","python":"def kthSmallest(matrix, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int kthSmallest(int[][] matrix, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,5,9],[10,11,13],[12,13,15]], 8","output":"13"},{"input":"[[-5]], 1","output":"-5"}]'::jsonb,
  '[]'::jsonb,
  '["Approach 1: Use a min heap with first element of each row.","When extracting min, add next element from same row to heap.","Approach 2: Binary search on answer range, count elements <= mid."]'::jsonb,
  61.8,
  '["Google","Facebook","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'k-th-smallest-prime-fraction',
  'K-th Smallest Prime Fraction',
  'k-th-smallest-prime-fraction',
  'medium',
  'You are given a sorted integer array `arr` containing `1` and prime numbers, where all the integers of `arr` are unique. You are also given an integer `k`.

For every `i` and `j` where `0 <= i < j < arr.length`, we consider the fraction `arr[i] / arr[j]`.

Return the `kth` smallest fraction considered. Return your answer as an array of integers of size `2`, where `answer[0] == arr[i]` and `answer[1] == arr[j]`.',
  '[{"input":"arr = [1,2,3,5], k = 3","output":"[2,5]","explanation":"The fractions to be considered in sorted order are:\n1/5, 1/3, 2/5, 1/2, 3/5, 2/3\nThe third fraction is 2/5."},{"input":"arr = [1,7], k = 1","output":"[1,7]"}]'::jsonb,
  '["2 <= arr.length <= 1000","1 <= arr[i] <= 3 * 10^4","arr[0] == 1","arr[i] is a prime number for i > 0","All the numbers of arr are unique and sorted in strictly increasing order","1 <= k <= arr.length * (arr.length - 1) / 2"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function kthSmallestPrimeFraction(arr, k) {\n  // Your code here\n}","python":"def kthSmallestPrimeFraction(arr, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] kthSmallestPrimeFraction(int[] arr, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,5], 3","output":"[2,5]"},{"input":"[1,7], 1","output":"[1,7]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap starting with arr[i]/arr[n-1] for all i.","When popping arr[i]/arr[j], add arr[i]/arr[j-1] to heap.","Alternative: Binary search on the fraction value."]'::jsonb,
  56.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'super-ugly-number',
  'Super Ugly Number',
  'super-ugly-number',
  'medium',
  'A super ugly number is a positive integer whose prime factors are in the array `primes`.

Given an integer `n` and an array of integers `primes`, return the `nth` super ugly number.

The `nth` super ugly number is guaranteed to fit in a 32-bit signed integer.',
  '[{"input":"n = 12, primes = [2,7,13,19]","output":"32","explanation":"[1,2,4,7,8,13,14,16,19,26,28,32] is the sequence of the first 12 super ugly numbers given primes = [2,7,13,19]."},{"input":"n = 1, primes = [2,3,5]","output":"1","explanation":"1 has no prime factors, therefore all of its prime factors are in the array primes = [2,3,5]."}]'::jsonb,
  '["1 <= n <= 10^5","1 <= primes.length <= 100","2 <= primes[i] <= 1000","primes[i] is guaranteed to be a prime number","All the values of primes are unique and sorted in ascending order"]'::jsonb,
  '["Array","Math","Dynamic Programming","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function nthSuperUglyNumber(n, primes) {\n  // Your code here\n}","python":"def nthSuperUglyNumber(n, primes):\n    # Your code here\n    pass","java":"class Solution {\n    public int nthSuperUglyNumber(int n, int[] primes) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"12, [2,7,13,19]","output":"32"},{"input":"1, [2,3,5]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Use dynamic programming with k pointers (one for each prime).","Each pointer tracks which ugly number to multiply with that prime next.","Always pick the minimum product and advance corresponding pointer(s).","Alternative: Use a min heap with all candidates."]'::jsonb,
  50.3,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'kth-largest-element-stream',
  'Kth Largest Element in a Stream',
  'kth-largest-element-stream',
  'easy',
  'Design a class to find the `kth` largest element in a stream. Note that it is the `kth` largest element in the sorted order, not the `kth` distinct element.

Implement `KthLargest` class:
- `KthLargest(int k, int[] nums)` Initializes the object with the integer `k` and the stream of integers `nums`.
- `int add(int val)` Appends the integer `val` to the stream and returns the element representing the `kth` largest element in the stream.',
  '[{"input":"[\"KthLargest\", \"add\", \"add\", \"add\", \"add\", \"add\"]\n[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]","output":"[null, 4, 5, 5, 8, 8]","explanation":"KthLargest kthLargest = new KthLargest(3, [4, 5, 8, 2]);\nkthLargest.add(3);   // return 4\nkthLargest.add(5);   // return 5\nkthLargest.add(10);  // return 5\nkthLargest.add(9);   // return 8\nkthLargest.add(4);   // return 8"}]'::jsonb,
  '["1 <= k <= 10^4","0 <= nums.length <= 10^4","-10^4 <= nums[i] <= 10^4","-10^4 <= val <= 10^4","At most 10^4 calls will be made to add","It is guaranteed that there will be at least k elements in the array when you search for the kth element"]'::jsonb,
  '["Tree","Design","Binary Search Tree","Heap","Binary Tree","Data Stream"]'::jsonb,
  'DSA',
  '{"javascript":"class KthLargest {\n  constructor(k, nums) {\n    // Your code here\n  }\n  \n  add(val) {\n    // Your code here\n  }\n}","python":"class KthLargest:\n    def __init__(self, k: int, nums: List[int]):\n        # Your code here\n        pass\n    \n    def add(self, val: int) -> int:\n        # Your code here\n        pass","java":"class KthLargest {\n    public KthLargest(int k, int[] nums) {\n        // Your code here\n    }\n    \n    public int add(int val) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[\"KthLargest\", \"add\", \"add\"], [[3, [4, 5, 8, 2]], [3], [5]]","output":"[null, 4, 5]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap of size k to keep track of k largest elements.","The root of the heap will be the kth largest element.","When adding, if heap size < k, just add. Otherwise, replace root if val > root."]'::jsonb,
  55.9,
  '["Amazon","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reorganize-string',
  'Reorganize String',
  'reorganize-string',
  'medium',
  'Given a string `s`, rearrange the characters of `s` so that any two adjacent characters are not the same.

Return any possible rearrangement of `s` or return `""` if not possible.',
  '[{"input":"s = \"aab\"","output":"\"aba\""},{"input":"s = \"aaab\"","output":"\"\"","explanation":"It is impossible to rearrange the string so that no two adjacent characters are the same."}]'::jsonb,
  '["1 <= s.length <= 500","s consists of lowercase English letters"]'::jsonb,
  '["Hash Table","String","Greedy","Sorting","Heap","Counting"]'::jsonb,
  'DSA',
  '{"javascript":"function reorganizeString(s) {\n  // Your code here\n}","python":"def reorganizeString(s):\n    # Your code here\n    pass","java":"class Solution {\n    public String reorganizeString(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"aab\"","output":"\"aba\""},{"input":"\"aaab\"","output":"\"\""}]'::jsonb,
  '[]'::jsonb,
  '["Use a max heap based on character frequency.","Always pick the most frequent character that''s different from the last one.","If any character has frequency > (n+1)/2, it''s impossible."]'::jsonb,
  56.8,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'k-closest-points-origin',
  'K Closest Points to Origin',
  'k-closest-points-origin',
  'medium',
  'Given an array of `points` where `points[i] = [xi, yi]` represents a point on the X-Y plane and an integer `k`, return the `k` closest points to the origin `(0, 0)`.

The distance between two points on the X-Y plane is the Euclidean distance (i.e., `√(x1 - x2)^2 + (y1 - y2)^2`).

You may return the answer in any order. The answer is guaranteed to be unique (except for the order that it is in).',
  '[{"input":"points = [[1,3],[-2,2]], k = 1","output":"[[-2,2]]","explanation":"The distance between (1, 3) and the origin is sqrt(10).\nThe distance between (-2, 2) and the origin is sqrt(8).\nSince sqrt(8) < sqrt(10), (-2, 2) is closer to the origin."},{"input":"points = [[3,3],[5,-1],[-2,4]], k = 2","output":"[[3,3],[-2,4]]","explanation":"The answer [[-2,4],[3,3]] would also be accepted."}]'::jsonb,
  '["1 <= k <= points.length <= 10^4","-10^4 <= xi, yi <= 10^4"]'::jsonb,
  '["Array","Math","Divide and Conquer","Geometry","Sorting","Heap","Quickselect"]'::jsonb,
  'DSA',
  '{"javascript":"function kClosest(points, k) {\n  // Your code here\n}","python":"def kClosest(points, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int[][] kClosest(int[][] points, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,3],[-2,2]], 1","output":"[[-2,2]]"},{"input":"[[3,3],[5,-1],[-2,4]], 2","output":"[[3,3],[-2,4]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a max heap of size k based on distance.","For each point, if heap size < k, add it. Otherwise, compare with max and replace if closer.","Alternative: Use quickselect algorithm for O(n) average case."]'::jsonb,
  66.8,
  '["Facebook","Amazon","Asana","LinkedIn"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'top-k-frequent-elements',
  'Top K Frequent Elements',
  'top-k-frequent-elements',
  'medium',
  'Given an integer array `nums` and an integer `k`, return the `k` most frequent elements. You may return the answer in any order.',
  '[{"input":"nums = [1,1,1,2,2,3], k = 2","output":"[1,2]"},{"input":"nums = [1], k = 1","output":"[1]"}]'::jsonb,
  '["1 <= nums.length <= 10^5","-10^4 <= nums[i] <= 10^4","k is in the range [1, the number of unique elements in the array]","It is guaranteed that the answer is unique"]'::jsonb,
  '["Array","Hash Table","Divide and Conquer","Sorting","Heap","Bucket Sort","Counting","Quickselect"]'::jsonb,
  'DSA',
  '{"javascript":"function topKFrequent(nums, k) {\n  // Your code here\n}","python":"def topKFrequent(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] topKFrequent(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,1,1,2,2,3], 2","output":"[1,2]"},{"input":"[1], 1","output":"[1]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a hash map to count frequencies.","Use a min heap of size k based on frequency.","Alternative: Bucket sort - create buckets for each frequency."]'::jsonb,
  64.9,
  '["Amazon","Facebook","Google","Bloomberg","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'kth-largest-element-array',
  'Kth Largest Element in an Array',
  'kth-largest-element-array',
  'medium',
  'Given an integer array `nums` and an integer `k`, return the `kth` largest element in the array.

Note that it is the `kth` largest element in the sorted order, not the `kth` distinct element.

Can you solve it without sorting?',
  '[{"input":"nums = [3,2,1,5,6,4], k = 2","output":"5"},{"input":"nums = [3,2,3,1,2,4,5,5,6], k = 4","output":"4"}]'::jsonb,
  '["1 <= k <= nums.length <= 10^5","-10^4 <= nums[i] <= 10^4"]'::jsonb,
  '["Array","Divide and Conquer","Sorting","Heap","Quickselect"]'::jsonb,
  'DSA',
  '{"javascript":"function findKthLargest(nums, k) {\n  // Your code here\n}","python":"def findKthLargest(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int findKthLargest(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[3,2,1,5,6,4], 2","output":"5"},{"input":"[3,2,3,1,2,4,5,5,6], 4","output":"4"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap of size k.","Maintain k largest elements in heap, root will be kth largest.","Alternative: Quickselect algorithm for O(n) average time."]'::jsonb,
  66.4,
  '["Facebook","Amazon","LinkedIn","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'third-maximum-number',
  'Third Maximum Number',
  'third-maximum-number',
  'easy',
  'Given an integer array `nums`, return the third distinct maximum number in this array. If the third maximum does not exist, return the maximum number.',
  '[{"input":"nums = [3,2,1]","output":"1","explanation":"The first distinct maximum is 3.\nThe second distinct maximum is 2.\nThe third distinct maximum is 1."},{"input":"nums = [1,2]","output":"2","explanation":"The first distinct maximum is 2.\nThe second distinct maximum is 1.\nThe third distinct maximum does not exist, so the maximum (2) is returned instead."},{"input":"nums = [2,2,3,1]","output":"1","explanation":"The first distinct maximum is 3.\nThe second distinct maximum is 2 (both 2''s are counted together).\nThe third distinct maximum is 1."}]'::jsonb,
  '["1 <= nums.length <= 10^4","-2^31 <= nums[i] <= 2^31 - 1"]'::jsonb,
  '["Array","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function thirdMax(nums) {\n  // Your code here\n}","python":"def thirdMax(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int thirdMax(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[3,2,1]","output":"1"},{"input":"[1,2]","output":"2"},{"input":"[2,2,3,1]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Keep track of top 3 distinct values while iterating.","Use three variables or a set to track distinct maximums.","Handle edge cases where less than 3 distinct numbers exist."]'::jsonb,
  34.1,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-subsequence-length-k',
  'Find Subsequence of Length K With the Largest Sum',
  'find-subsequence-length-k',
  'easy',
  'You are given an integer array `nums` and an integer `k`. You want to find a subsequence of `nums` of length `k` that has the largest sum.

Return any such subsequence as an integer array of length `k`.

A subsequence is an array that can be derived from another array by deleting some or no elements without changing the order of the remaining elements.',
  '[{"input":"nums = [2,1,3,3], k = 2","output":"[3,3]","explanation":"The subsequence has the largest sum of 3 + 3 = 6."},{"input":"nums = [-1,-2,3,4], k = 3","output":"[-1,3,4]","explanation":"The subsequence has the largest sum of -1 + 3 + 4 = 6."}]'::jsonb,
  '["1 <= nums.length <= 1000","-10^5 <= nums[i] <= 10^5","1 <= k <= nums.length"]'::jsonb,
  '["Array","Hash Table","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function maxSubsequence(nums, k) {\n  // Your code here\n}","python":"def maxSubsequence(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] maxSubsequence(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,1,3,3], 2","output":"[3,3]"},{"input":"[-1,-2,3,4], 3","output":"[-1,3,4]"}]'::jsonb,
  '[]'::jsonb,
  '["Find k largest elements using heap or sorting.","Track their original indices to maintain order.","Return elements in their original relative order."]'::jsonb,
  51.3,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-cost-hire-k-workers',
  'Minimum Cost to Hire K Workers',
  'minimum-cost-hire-k-workers',
  'hard',
  'There are `n` workers. You are given two integer arrays `quality` and `wage` where `quality[i]` is the quality of the `ith` worker and `wage[i]` is the minimum wage expectation for the `ith` worker.

We want to hire exactly `k` workers to form a paid group. To hire a group of `k` workers, we must pay them according to the following rules:
1. Every worker in the paid group must be paid at least their minimum wage expectation.
2. In the group, each worker''s pay must be directly proportional to their quality. This means if a worker''s quality is double that of another worker in the group, then they must be paid twice as much as the other worker.

Given the integer `k`, return the least amount of money needed to form a paid group satisfying the above conditions. Answers within `10^-5` of the actual answer will be accepted.',
  '[{"input":"quality = [10,20,5], wage = [70,50,30], k = 2","output":"105.00000","explanation":"We pay 70 to 0th worker and 35 to 2nd worker."},{"input":"quality = [3,1,10,10,1], wage = [4,8,2,2,7], k = 3","output":"30.66667","explanation":"We pay 4 to 0th worker, 13.33333 to 2nd and 3rd workers separately."}]'::jsonb,
  '["n == quality.length == wage.length","1 <= k <= n <= 10^4","1 <= quality[i], wage[i] <= 10^4"]'::jsonb,
  '["Array","Greedy","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function mincostToHireWorkers(quality, wage, k) {\n  // Your code here\n}","python":"def mincostToHireWorkers(quality, wage, k):\n    # Your code here\n    pass","java":"class Solution {\n    public double mincostToHireWorkers(int[] quality, int[] wage, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[10,20,5], [70,50,30], 2","output":"105.00000"},{"input":"[3,1,10,10,1], [4,8,2,2,7], 3","output":"30.66667"}]'::jsonb,
  '[]'::jsonb,
  '["Sort workers by wage/quality ratio.","Use max heap to track k smallest qualities.","For each worker as captain, calculate total cost for group."]'::jsonb,
  54.2,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximal-score-k-operations',
  'Maximal Score After Applying K Operations',
  'maximal-score-k-operations',
  'medium',
  'You are given a 0-indexed integer array `nums` and an integer `k`. You have a starting score of `0`.

In one operation:
1. choose an index `i` such that `0 <= i < nums.length`,
2. increase your score by `nums[i]`, and
3. replace `nums[i]` with `ceil(nums[i] / 3)`.

Return the maximum possible score you can attain after applying exactly `k` operations.

The ceiling function `ceil(val)` is the least integer greater than or equal to `val`.',
  '[{"input":"nums = [10,10,10,10,10], k = 5","output":"50","explanation":"Apply the operation to each array element exactly once. The final score is 10 + 10 + 10 + 10 + 10 = 50."},{"input":"nums = [1,10,3,3,3], k = 3","output":"17","explanation":"You can do the following operations:\nOperation 1: Select i = 1, so nums becomes [1,4,3,3,3]. Your score increases by 10.\nOperation 2: Select i = 1, so nums becomes [1,2,3,3,3]. Your score increases by 4.\nOperation 3: Select i = 2, so nums becomes [1,1,1,3,3]. Your score increases by 3.\nThe final score is 10 + 4 + 3 = 17."}]'::jsonb,
  '["1 <= nums.length, k <= 10^5","1 <= nums[i] <= 10^9"]'::jsonb,
  '["Array","Greedy","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function maxKelements(nums, k) {\n  // Your code here\n}","python":"def maxKelements(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public long maxKelements(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[10,10,10,10,10], 5","output":"50"},{"input":"[1,10,3,3,3], 3","output":"17"}]'::jsonb,
  '[]'::jsonb,
  '["Use a max heap to always pick the largest element.","After picking, add to score and push ceil(val/3) back to heap.","Repeat k times."]'::jsonb,
  45.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-kth-largest-integer',
  'Find the Kth Largest Integer in the Array',
  'find-kth-largest-integer',
  'medium',
  'You are given an array of strings `nums` and an integer `k`. Each string in `nums` represents an integer without leading zeros.

Return the string that represents the `kth` largest integer in `nums`.

Note: Duplicate numbers should be counted distinctly. For example, if `nums` is `["1","2","2"]`, `"2"` is the first largest integer, `"2"` is the second-largest integer, and `"1"` is the third-largest integer.',
  '[{"input":"nums = [\"3\",\"6\",\"7\",\"10\"], k = 4","output":"\"3\"","explanation":"The numbers in nums sorted in non-decreasing order are [\"3\",\"6\",\"7\",\"10\"].\nThe 4th largest integer in nums is \"3\"."},{"input":"nums = [\"2\",\"21\",\"12\",\"1\"], k = 3","output":"\"2\"","explanation":"The numbers in nums sorted in non-decreasing order are [\"1\",\"2\",\"12\",\"21\"].\nThe 3rd largest integer in nums is \"2\"."}]'::jsonb,
  '["1 <= k <= nums.length <= 10^4","1 <= nums[i].length <= 100","nums[i] consists of only digits","nums[i] will not have any leading zeros"]'::jsonb,
  '["Array","String","Divide and Conquer","Sorting","Heap","Quickselect"]'::jsonb,
  'DSA',
  '{"javascript":"function kthLargestNumber(nums, k) {\n  // Your code here\n}","python":"def kthLargestNumber(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public String kthLargestNumber(String[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[\"3\",\"6\",\"7\",\"10\"], 4","output":"\"3\""},{"input":"[\"2\",\"21\",\"12\",\"1\"], 3","output":"\"2\""}]'::jsonb,
  '[]'::jsonb,
  '["Compare strings by length first, then lexicographically if same length.","Use min heap of size k with custom comparator.","Can also sort with custom comparator and return nums[n-k]."]'::jsonb,
  44.9,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-performance-team',
  'Maximum Performance of a Team',
  'maximum-performance-team',
  'hard',
  'You are given two integers `n` and `k` and two integer arrays `speed` and `efficiency` both of length `n`. There are `n` engineers numbered from `1` to `n`. `speed[i]` and `efficiency[i]` represent the speed and efficiency of the `ith` engineer respectively.

Choose at most `k` different engineers out of the `n` engineers to form a team with the maximum performance.

The performance of a team is the sum of their engineers'' speeds multiplied by the minimum efficiency among their engineers.

Return the maximum performance of this team. Since the answer can be a huge number, return it modulo `10^9 + 7`.',
  '[{"input":"n = 6, speed = [2,10,3,1,5,8], efficiency = [5,4,3,9,7,2], k = 2","output":"60","explanation":"We have the maximum performance of the team by selecting engineer 2 (with speed=10 and efficiency=4) and engineer 5 (with speed=5 and efficiency=7). That is, performance = (10 + 5) * min(4, 7) = 60."},{"input":"n = 6, speed = [2,10,3,1,5,8], efficiency = [5,4,3,9,7,2], k = 3","output":"68","explanation":"This is the same example as the first but k = 3. We can select engineer 1, engineer 2 and engineer 5 to get the maximum performance of the team. That is, performance = (2 + 10 + 5) * min(5, 4, 7) = 68."}]'::jsonb,
  '["1 <= k <= n <= 10^5","speed.length == n","efficiency.length == n","1 <= speed[i] <= 10^5","1 <= efficiency[i] <= 10^8"]'::jsonb,
  '["Array","Greedy","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function maxPerformance(n, speed, efficiency, k) {\n  // Your code here\n}","python":"def maxPerformance(n, speed, efficiency, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxPerformance(int n, int[] speed, int[] efficiency, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"6, [2,10,3,1,5,8], [5,4,3,9,7,2], 2","output":"60"},{"input":"6, [2,10,3,1,5,8], [5,4,3,9,7,2], 3","output":"68"}]'::jsonb,
  '[]'::jsonb,
  '["Sort engineers by efficiency in descending order.","Use min heap to track k largest speeds.","For each engineer as minimum efficiency, calculate performance."]'::jsonb,
  46.8,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'smallest-range-k-lists',
  'Smallest Range Covering Elements from K Lists',
  'smallest-range-k-lists',
  'hard',
  'You have `k` lists of sorted integers in non-decreasing order. Find the smallest range that includes at least one number from each of the `k` lists.

We define the range `[a, b]` is smaller than range `[c, d]` if `b - a < d - c` or `a < c` if `b - a == d - c`.',
  '[{"input":"nums = [[4,10,15,24,26],[0,9,12,20],[5,18,22,30]]","output":"[20,24]","explanation":"List 1: [4, 10, 15, 24,26], 24 is in range [20,24].\nList 2: [0, 9, 12, 20], 20 is in range [20,24].\nList 3: [5, 18, 22, 30], 22 is in range [20,24]."}]'::jsonb,
  '["nums.length == k","1 <= k <= 3500","1 <= nums[i].length <= 50","-10^5 <= nums[i][j] <= 10^5","nums[i] is sorted in non-decreasing order"]'::jsonb,
  '["Array","Hash Table","Greedy","Sliding Window","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function smallestRange(nums) {\n  // Your code here\n}","python":"def smallestRange(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] smallestRange(List<List<Integer>> nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[4,10,15,24,26],[0,9,12,20],[5,18,22,30]]","output":"[20,24]"}]'::jsonb,
  '[]'::jsonb,
  '["Use min heap with first element from each list.","Track current max among heap elements.","Pop min, update range if smaller, add next element from same list."]'::jsonb,
  60.1,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'k-empty-slots',
  'K Empty Slots',
  'k-empty-slots',
  'hard',
  'You have `n` bulbs in a row numbered from `1` to `n`. Initially, all the bulbs are turned off. We turn on exactly one bulb every day until all bulbs are on after `n` days.

You are given an array `bulbs` of length `n` where `bulbs[i] = x` means that on the `(i+1)th` day, we will turn on the bulb at position `x` where `i` is 0-indexed and `x` is 1-indexed.

Given an integer `k`, return the minimum day number such that there exists two turned on bulbs that have exactly `k` bulbs between them that are all turned off. If there isn''t such day, return `-1`.',
  '[{"input":"bulbs = [1,3,2], k = 1","output":"2","explanation":"On the first day: bulbs[0] = 1, first bulb is turned on: [1,0,0]\nOn the second day: bulbs[1] = 3, third bulb is turned on: [1,0,1]\nOn the third day: bulbs[2] = 2, second bulb is turned on: [1,1,1]\nWe return 2 because on the second day, there were two on bulbs with one off bulb between them."},{"input":"bulbs = [1,2,3], k = 1","output":"-1"}]'::jsonb,
  '["n == bulbs.length","1 <= n <= 2 * 10^4","1 <= bulbs[i] <= n","bulbs is a permutation of numbers from 1 to n","0 <= k <= 2 * 10^4"]'::jsonb,
  '["Array","Binary Search","Sliding Window","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"function kEmptySlots(bulbs, k) {\n  // Your code here\n}","python":"def kEmptySlots(bulbs, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int kEmptySlots(int[] bulbs, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,3,2], 1","output":"2"},{"input":"[1,2,3], 1","output":"-1"}]'::jsonb,
  '[]'::jsonb,
  '["Track when each bulb turns on using days array.","Use sliding window to check if k consecutive bulbs turn on later than boundaries.","Alternative: Use TreeSet to maintain sorted positions of on bulbs."]'::jsonb,
  37.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'choose-k-elements-max-sum',
  'Choose K Elements With Maximum Sum',
  'choose-k-elements-max-sum',
  'medium',
  'You are given an integer array `nums` of size `n` and a positive integer `k`.

You need to choose exactly `k` elements from `nums` such that the sum of these elements is maximized.

Return the maximum sum you can get.',
  '[{"input":"nums = [1,2,3,4,5], k = 3","output":"12","explanation":"Choose elements 3, 4, and 5 to get sum = 12."},{"input":"nums = [-1,-2,-3,-4,-5], k = 2","output":"-3","explanation":"Choose elements -1 and -2 to get sum = -3."}]'::jsonb,
  '["1 <= k <= n <= 10^5","-10^9 <= nums[i] <= 10^9"]'::jsonb,
  '["Array","Greedy","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function maxSum(nums, k) {\n  // Your code here\n}","python":"def maxSum(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public long maxSum(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5], 3","output":"12"},{"input":"[-1,-2,-3,-4,-5], 2","output":"-3"}]'::jsonb,
  '[]'::jsonb,
  '["Simply sort the array in descending order.","Take first k elements.","Alternative: Use max heap to get k largest."]'::jsonb,
  72.1,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-product-after-k-increments',
  'Maximum Product After K Increments',
  'maximum-product-after-k-increments',
  'medium',
  'You are given an array of non-negative integers `nums` and an integer `k`. In one operation, you may choose any element from `nums` and increment it by `1`.

Return the maximum product of `nums` after at most `k` operations. Since the answer may be very large, return it modulo `10^9 + 7`. Note that you should maximize the product before taking the modulo.',
  '[{"input":"nums = [0,4], k = 5","output":"20","explanation":"Increment the first number 5 times.\nNow nums = [5, 4], with a product of 5 * 4 = 20.\nIt can be shown that 20 is maximum product possible, so we return 20."},{"input":"nums = [6,3,3,2], k = 2","output":"216","explanation":"Increment the second number 1 time and increment the fourth number 1 time.\nNow nums = [6, 4, 3, 3], with a product of 6 * 4 * 3 * 3 = 216.\nIt can be shown that 216 is maximum product possible, so we return 216."}]'::jsonb,
  '["1 <= nums.length, k <= 10^5","0 <= nums[i] <= 10^6"]'::jsonb,
  '["Array","Greedy","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function maximumProduct(nums, k) {\n  // Your code here\n}","python":"def maximumProduct(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int maximumProduct(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[0,4], 5","output":"20"},{"input":"[6,3,3,2], 2","output":"216"}]'::jsonb,
  '[]'::jsonb,
  '["Use min heap to always increment the smallest element.","After k operations, calculate product with modulo.","Greedy approach: making smallest element larger increases product more."]'::jsonb,
  43.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-k-sum-array',
  'Find the K-Sum of an Array',
  'find-k-sum-array',
  'hard',
  'You are given an integer array `nums` and a positive integer `k`. You can choose any subsequence of the array and sum all of its elements together.

We define the K-Sum of the array as the `kth` largest subsequence sum that can be obtained (not necessarily distinct).

Return the K-Sum of the array.',
  '[{"input":"nums = [2,4,-2], k = 5","output":"2","explanation":"All the possible subsequence sums that we can obtain are the following sorted in decreasing order:\n- 6, 4, 4, 2, 2, 0, 0, -2.\nThe 5th largest subsequence sum is 2."},{"input":"nums = [1,-2,3,4,-10,12], k = 16","output":"10","explanation":"The 16th largest subsequence sum is 10."}]'::jsonb,
  '["n == nums.length","1 <= n <= 10^5","-10^9 <= nums[i] <= 10^9","1 <= k <= min(2000, 2^n)"]'::jsonb,
  '["Array","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function kSum(nums, k) {\n  // Your code here\n}","python":"def kSum(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public long kSum(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,4,-2], 5","output":"2"},{"input":"[1,-2,3,4,-10,12], 16","output":"10"}]'::jsonb,
  '[]'::jsonb,
  '["Start with sum of all positive numbers (maximum sum).","Use max heap to generate next smaller sums by excluding/swapping elements.","Make negative numbers positive and treat as reducing from max sum."]'::jsonb,
  35.4,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'least-unique-integers-k-removals',
  'Least Number of Unique Integers after K Removals',
  'least-unique-integers-k-removals',
  'medium',
  'Given an array of integers `arr` and an integer `k`. Find the least number of unique integers after removing exactly `k` elements.',
  '[{"input":"arr = [5,5,4], k = 1","output":"1","explanation":"Remove the single 4, only 5 is left."},{"input":"arr = [4,3,1,1,3,3,2], k = 3","output":"2","explanation":"Remove 4, 2 and either one of the two 1s or three 3s. 1 and 3 will be left."}]'::jsonb,
  '["1 <= arr.length <= 10^5","1 <= arr[i] <= 10^9","0 <= k <= arr.length"]'::jsonb,
  '["Array","Hash Table","Greedy","Sorting","Counting"]'::jsonb,
  'DSA',
  '{"javascript":"function findLeastNumOfUniqueInts(arr, k) {\n  // Your code here\n}","python":"def findLeastNumOfUniqueInts(arr, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int findLeastNumOfUniqueInts(int[] arr, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[5,5,4], 1","output":"1"},{"input":"[4,3,1,1,3,3,2], 3","output":"2"}]'::jsonb,
  '[]'::jsonb,
  '["Count frequency of each number.","Sort by frequency and remove elements with smallest frequencies first.","Use min heap or sort frequencies to greedily remove."]'::jsonb,
  59.8,
  '["Amazon","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'final-array-state-k-multiplication-1',
  'Final Array State After K Multiplication Operations I',
  'final-array-state-k-multiplication-1',
  'easy',
  'You are given an integer array `nums`, an integer `k`, and an integer `multiplier`.

You need to perform `k` operations on `nums`. In each operation:
- Find the minimum value `x` in `nums`. If there are multiple occurrences of the minimum value, select the one that appears first.
- Replace the selected minimum value `x` with `x * multiplier`.

Return an integer array denoting the final state of `nums` after performing all `k` operations.',
  '[{"input":"nums = [2,1,3,5,6], k = 5, multiplier = 2","output":"[8,4,6,5,6]","explanation":"Operation\tResult\nAfter operation 1\t[2, 2, 3, 5, 6]\nAfter operation 2\t[4, 2, 3, 5, 6]\nAfter operation 3\t[4, 4, 3, 5, 6]\nAfter operation 4\t[4, 4, 6, 5, 6]\nAfter operation 5\t[8, 4, 6, 5, 6]"},{"input":"nums = [1,2], k = 3, multiplier = 4","output":"[16,8]"}]'::jsonb,
  '["1 <= nums.length <= 100","1 <= nums[i] <= 100","1 <= k <= 10","1 <= multiplier <= 5"]'::jsonb,
  '["Array","Math","Heap","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function getFinalState(nums, k, multiplier) {\n  // Your code here\n}","python":"def getFinalState(nums, k, multiplier):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] getFinalState(int[] nums, int k, int multiplier) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,1,3,5,6], 5, 2","output":"[8,4,6,5,6]"},{"input":"[1,2], 3, 4","output":"[16,8]"}]'::jsonb,
  '[]'::jsonb,
  '["Use a min heap with (value, index) pairs.","Extract min, multiply, and reinsert k times.","Track indices to handle ties (first occurrence)."]'::jsonb,
  58.3,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'final-array-state-k-multiplication-2',
  'Final Array State After K Multiplication Operations II',
  'final-array-state-k-multiplication-2',
  'hard',
  'You are given an integer array `nums`, an integer `k`, and an integer `multiplier`.

You need to perform `k` operations on `nums`. In each operation:
- Find the minimum value `x` in `nums`. If there are multiple occurrences of the minimum value, select the one that appears first.
- Replace the selected minimum value `x` with `x * multiplier`.

After the `k` operations, apply modulo `10^9 + 7` to every value in `nums`.

Return an integer array denoting the final state of `nums` after performing all `k` operations and then applying the modulo.',
  '[{"input":"nums = [2,1,3,5,6], k = 5, multiplier = 2","output":"[8,4,6,5,6]"},{"input":"nums = [100000,2000], k = 2, multiplier = 1000000","output":"[999999307,999999993]","explanation":"After operation 1: [100000, 2000000000]\nAfter operation 2: [100000000000, 2000000000]\nAfter applying modulo: [999999307, 999999993]"}]'::jsonb,
  '["1 <= nums.length <= 10^4","1 <= nums[i] <= 10^9","1 <= k <= 10^9","1 <= multiplier <= 10^6"]'::jsonb,
  '["Array","Math","Heap","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function getFinalState(nums, k, multiplier) {\n  // Your code here\n}","python":"def getFinalState(nums, k, multiplier):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] getFinalState(int[] nums, int k, int multiplier) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,1,3,5,6], 5, 2","output":"[8,4,6,5,6]"},{"input":"[100000,2000], 2, 1000000","output":"[999999307,999999993]"}]'::jsonb,
  '[]'::jsonb,
  '["For large k, optimize by calculating how many full rounds all elements get.","Use modular exponentiation for large multiplications.","Simulate remaining operations with heap after full rounds."]'::jsonb,
  28.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-search-704',
  'Binary Search',
  'binary-search-704',
  'easy',
  'Given an array of integers `nums` which is sorted in ascending order, and an integer `target`, write a function to search `target` in `nums`. If `target` exists, then return its index. Otherwise, return `-1`.

You must write an algorithm with `O(log n)` runtime complexity.',
  '[{"input":"nums = [-1,0,3,5,9,12], target = 9","output":"4","explanation":"9 exists in nums and its index is 4"},{"input":"nums = [-1,0,3,5,9,12], target = 2","output":"-1","explanation":"2 does not exist in nums so return -1"}]'::jsonb,
  '["1 <= nums.length <= 10^4","-10^4 < nums[i], target < 10^4","All the integers in nums are unique","nums is sorted in ascending order"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function search(nums, target) {\n  // Your code here\n}","python":"def search(nums, target):\n    # Your code here\n    pass","java":"class Solution {\n    public int search(int[] nums, int target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[-1,0,3,5,9,12], 9","output":"4"},{"input":"[-1,0,3,5,9,12], 2","output":"-1"}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers, left and right, to track the search space.","Calculate mid = left + (right - left) / 2 to avoid overflow.","If nums[mid] == target, return mid. If nums[mid] < target, search right half. Otherwise, search left half."]'::jsonb,
  55.2,
  '["Amazon","Facebook","Google","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'search-rotated-sorted-array',
  'Search in Rotated Sorted Array',
  'search-rotated-sorted-array',
  'medium',
  'There is an integer array `nums` sorted in ascending order (with distinct values).

Prior to being passed to your function, `nums` is possibly rotated at an unknown pivot index `k` (`1 <= k < nums.length`) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (0-indexed). For example, `[0,1,2,4,5,6,7]` might be rotated at pivot index `3` and become `[4,5,6,7,0,1,2]`.

Given the array `nums` after the possible rotation and an integer `target`, return the index of `target` if it is in `nums`, or `-1` if it is not in `nums`.

You must write an algorithm with `O(log n)` runtime complexity.',
  '[{"input":"nums = [4,5,6,7,0,1,2], target = 0","output":"4"},{"input":"nums = [4,5,6,7,0,1,2], target = 3","output":"-1"},{"input":"nums = [1], target = 0","output":"-1"}]'::jsonb,
  '["1 <= nums.length <= 5000","-10^4 <= nums[i] <= 10^4","All values of nums are unique","nums is an ascending array that is possibly rotated","-10^4 <= target <= 10^4"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function search(nums, target) {\n  // Your code here\n}","python":"def search(nums, target):\n    # Your code here\n    pass","java":"class Solution {\n    public int search(int[] nums, int target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[4,5,6,7,0,1,2], 0","output":"4"},{"input":"[4,5,6,7,0,1,2], 3","output":"-1"},{"input":"[1], 0","output":"-1"}]'::jsonb,
  '[]'::jsonb,
  '["One half of the array is always sorted after rotation.","Check which half is sorted by comparing nums[left] with nums[mid].","If target is in the sorted half''s range, search there. Otherwise, search the other half."]'::jsonb,
  39.2,
  '["Facebook","Amazon","Microsoft","LinkedIn","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'first-bad-version',
  'First Bad Version',
  'first-bad-version',
  'easy',
  'You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

Suppose you have `n` versions `[1, 2, ..., n]` and you want to find out the first bad one, which causes all the following ones to be bad.

You are given an API `bool isBadVersion(version)` which returns whether `version` is bad. Implement a function to find the first bad version. You should minimize the number of calls to the API.',
  '[{"input":"n = 5, bad = 4","output":"4","explanation":"call isBadVersion(3) -> false\ncall isBadVersion(5) -> true\ncall isBadVersion(4) -> true\nThen 4 is the first bad version."},{"input":"n = 1, bad = 1","output":"1"}]'::jsonb,
  '["1 <= bad <= n <= 2^31 - 1"]'::jsonb,
  '["Binary Search","Interactive"]'::jsonb,
  'DSA',
  '{"javascript":"function solution(isBadVersion) {\n  return function(n) {\n    // Your code here\n  };\n}","python":"def firstBadVersion(n):\n    # Your code here\n    pass","java":"public class Solution extends VersionControl {\n    public int firstBadVersion(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"5, bad = 4","output":"4"},{"input":"1, bad = 1","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Use binary search on the range [1, n].","If isBadVersion(mid) is true, search left half (including mid).","If false, search right half (excluding mid).","Be careful with integer overflow when calculating mid."]'::jsonb,
  43.9,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'random-pick-weight',
  'Random Pick with Weight',
  'random-pick-weight',
  'medium',
  'You are given a 0-indexed array of positive integers `w` where `w[i]` describes the weight of the `ith` index.

You need to implement the function `pickIndex()`, which randomly picks an index in the range `[0, w.length - 1]` (inclusive) and returns it. The probability of picking an index `i` is `w[i] / sum(w)`.',
  '[{"input":"[\"Solution\",\"pickIndex\"]\n[[[1]],[]]","output":"[null,0]","explanation":"Solution solution = new Solution([1]);\nsolution.pickIndex(); // return 0. The only option is to return 0 since there is only one element in w."},{"input":"[\"Solution\",\"pickIndex\",\"pickIndex\",\"pickIndex\",\"pickIndex\",\"pickIndex\"]\n[[[1,3]],[],[],[],[],[]]","output":"[null,1,1,1,1,0]","explanation":"Solution solution = new Solution([1, 3]);\nsolution.pickIndex(); // return 1. It is returning the second element (index = 1) that has a probability of 3/4.\nsolution.pickIndex(); // return 1\nsolution.pickIndex(); // return 1\nsolution.pickIndex(); // return 1\nsolution.pickIndex(); // return 0. It is returning the first element (index = 0) that has a probability of 1/4."}]'::jsonb,
  '["1 <= w.length <= 10^4","1 <= w[i] <= 10^5","pickIndex will be called at most 10^4 times"]'::jsonb,
  '["Array","Math","Binary Search","Prefix Sum","Randomized"]'::jsonb,
  'DSA',
  '{"javascript":"class Solution {\n  constructor(w) {\n    // Your code here\n  }\n  \n  pickIndex() {\n    // Your code here\n  }\n}","python":"class Solution:\n    def __init__(self, w: List[int]):\n        # Your code here\n        pass\n    \n    def pickIndex(self) -> int:\n        # Your code here\n        pass","java":"class Solution {\n    public Solution(int[] w) {\n        // Your code here\n    }\n    \n    public int pickIndex() {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[\"Solution\",\"pickIndex\"], [[[1]],[]]","output":"[null,0]"}]'::jsonb,
  '[]'::jsonb,
  '["Create a prefix sum array where prefix[i] = sum of w[0] to w[i].","Generate random number in range [1, total_sum].","Use binary search to find the index where this random number falls."]'::jsonb,
  46.8,
  '["Facebook","Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-k-closest-elements',
  'Find K Closest Elements',
  'find-k-closest-elements',
  'medium',
  'Given a sorted integer array `arr`, two integers `k` and `x`, return the `k` closest integers to `x` in the array. The result should also be sorted in ascending order.

An integer `a` is closer to `x` than an integer `b` if:
- `|a - x| < |b - x|`, or
- `|a - x| == |b - x|` and `a < b`',
  '[{"input":"arr = [1,2,3,4,5], k = 4, x = 3","output":"[1,2,3,4]"},{"input":"arr = [1,2,3,4,5], k = 4, x = -1","output":"[1,2,3,4]"}]'::jsonb,
  '["1 <= k <= arr.length","1 <= arr.length <= 10^4","arr is sorted in ascending order","-10^4 <= arr[i], x <= 10^4"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Sliding Window","Sorting","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function findClosestElements(arr, k, x) {\n  // Your code here\n}","python":"def findClosestElements(arr, k, x):\n    # Your code here\n    pass","java":"class Solution {\n    public List<Integer> findClosestElements(int[] arr, int k, int x) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5], 4, 3","output":"[1,2,3,4]"},{"input":"[1,2,3,4,5], 4, -1","output":"[1,2,3,4]"}]'::jsonb,
  '[]'::jsonb,
  '["Binary search for the starting position of k elements.","The window of k elements should have left boundary at position that minimizes distance.","Compare arr[mid] and arr[mid+k] with x to decide search direction."]'::jsonb,
  46.3,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'single-element-sorted-array',
  'Single Element in a Sorted Array',
  'single-element-sorted-array',
  'medium',
  'You are given a sorted array consisting of only integers where every element appears exactly twice, except for one element which appears exactly once.

Return the single element that appears only once.

Your solution must run in `O(log n)` time and `O(1)` space.',
  '[{"input":"nums = [1,1,2,3,3,4,4,8,8]","output":"2"},{"input":"nums = [3,3,7,7,10,11,11]","output":"10"}]'::jsonb,
  '["1 <= nums.length <= 10^5","0 <= nums[i] <= 10^5"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function singleNonDuplicate(nums) {\n  // Your code here\n}","python":"def singleNonDuplicate(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int singleNonDuplicate(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,1,2,3,3,4,4,8,8]","output":"2"},{"input":"[3,3,7,7,10,11,11]","output":"10"}]'::jsonb,
  '[]'::jsonb,
  '["Use binary search on even indices.","If nums[mid] == nums[mid+1] and mid is even, single element is on right.","If nums[mid] == nums[mid-1] and mid is odd, single element is on right.","Otherwise, search left."]'::jsonb,
  58.4,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-value-given-index',
  'Maximum Value at a Given Index in a Bounded Array',
  'maximum-value-given-index',
  'medium',
  'You are given three positive integers: `n`, `index`, and `maxSum`. You want to construct an array `nums` (0-indexed) that satisfies the following conditions:
- `nums.length == n`
- `nums[i]` is a positive integer where `0 <= i < n`
- `abs(nums[i] - nums[i+1]) <= 1` where `0 <= i < n-1`
- The sum of all the elements of `nums` does not exceed `maxSum`
- `nums[index]` is maximized

Return `nums[index]` of the constructed array.

Note that `abs(x)` equals `x` if `x >= 0`, and `-x` otherwise.',
  '[{"input":"n = 4, index = 2,  maxSum = 6","output":"2","explanation":"nums = [1,2,2,1] is one array that satisfies all the conditions.\nThere are no arrays that satisfy all the conditions and have nums[2] == 3, so 2 is the maximum nums[2]."},{"input":"n = 6, index = 1,  maxSum = 10","output":"3"}]'::jsonb,
  '["1 <= n <= maxSum <= 10^9","0 <= index < n"]'::jsonb,
  '["Binary Search","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function maxValue(n, index, maxSum) {\n  // Your code here\n}","python":"def maxValue(n, index, maxSum):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxValue(int n, int index, int maxSum) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"4, 2, 6","output":"2"},{"input":"6, 1, 10","output":"3"}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on the answer (value at index).","For a given value, calculate minimum sum needed using arithmetic series.","Check if calculated sum <= maxSum."]'::jsonb,
  33.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'k-weakest-rows',
  'The K Weakest Rows in a Matrix',
  'k-weakest-rows',
  'easy',
  'You are given an `m x n` binary matrix `mat` of `1`''s (representing soldiers) and `0`''s (representing civilians). The soldiers are positioned in front of the civilians. That is, all the `1`''s will appear to the left of all the `0`''s in each row.

A row `i` is weaker than a row `j` if one of the following is true:
- The number of soldiers in row `i` is less than the number of soldiers in row `j`.
- Both rows have the same number of soldiers and `i < j`.

Return the indices of the `k` weakest rows in the matrix ordered from weakest to strongest.',
  '[{"input":"mat = [[1,1,0,0,0],[1,1,1,1,0],[1,0,0,0,0],[1,1,0,0,0],[1,1,1,1,1]], k = 3","output":"[2,0,3]","explanation":"The number of soldiers in each row is:\n- Row 0: 2\n- Row 1: 4\n- Row 2: 1\n- Row 3: 2\n- Row 4: 5\nThe rows ordered from weakest to strongest are [2,0,3,1,4]."},{"input":"mat = [[1,0,0,0],[1,1,1,1],[1,0,0,0],[1,0,0,0]], k = 2","output":"[0,2]","explanation":"The number of soldiers in each row is:\n- Row 0: 1\n- Row 1: 4\n- Row 2: 1\n- Row 3: 1\nThe rows ordered from weakest to strongest are [0,2,3,1]."}]'::jsonb,
  '["m == mat.length","n == mat[i].length","2 <= n, m <= 100","1 <= k <= m","matrix[i][j] is either 0 or 1"]'::jsonb,
  '["Array","Binary Search","Sorting","Heap","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function kWeakestRows(mat, k) {\n  // Your code here\n}","python":"def kWeakestRows(mat, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] kWeakestRows(int[][] mat, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,1,0,0,0],[1,1,1,1,0],[1,0,0,0,0],[1,1,0,0,0],[1,1,1,1,1]], 3","output":"[2,0,3]"},{"input":"[[1,0,0,0],[1,1,1,1],[1,0,0,0],[1,0,0,0]], 2","output":"[0,2]"}]'::jsonb,
  '[]'::jsonb,
  '["Use binary search on each row to count soldiers (find last 1).","Store (count, index) pairs and sort.","Return first k indices."]'::jsonb,
  74.8,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'split-array-largest-sum',
  'Split Array Largest Sum',
  'split-array-largest-sum',
  'hard',
  'Given an integer array `nums` and an integer `k`, split `nums` into `k` non-empty subarrays such that the largest sum of any subarray is minimized.

Return the minimized largest sum of the split.

A subarray is a contiguous part of the array.',
  '[{"input":"nums = [7,2,5,10,8], k = 2","output":"18","explanation":"There are four ways to split nums into two subarrays.\nThe best way is to split it into [7,2,5] and [10,8], where the largest sum among the two subarrays is only 18."},{"input":"nums = [1,2,3,4,5], k = 2","output":"9"}]'::jsonb,
  '["1 <= nums.length <= 1000","0 <= nums[i] <= 10^6","1 <= k <= min(50, nums.length)"]'::jsonb,
  '["Array","Binary Search","Dynamic Programming","Greedy","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function splitArray(nums, k) {\n  // Your code here\n}","python":"def splitArray(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int splitArray(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[7,2,5,10,8], 2","output":"18"},{"input":"[1,2,3,4,5], 2","output":"9"}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on the answer (max sum).","For a given max sum, check if we can split into k or fewer subarrays.","Greedily fill subarrays up to max sum and count required splits."]'::jsonb,
  54.9,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-minimum-rotated-sorted-ii',
  'Find Minimum in Rotated Sorted Array II',
  'find-minimum-rotated-sorted-ii',
  'hard',
  'Suppose an array of length `n` sorted in ascending order is rotated between `1` and `n` times. For example, the array `nums = [0,1,4,4,5,6,7]` might become:
- `[4,5,6,7,0,1,4]` if it was rotated `4` times.
- `[0,1,4,4,5,6,7]` if it was rotated `7` times.

Notice that rotating an array `[a[0], a[1], a[2], ..., a[n-1]]` 1 time results in the array `[a[n-1], a[0], a[1], a[2], ..., a[n-2]]`.

Given the sorted rotated array `nums` that may contain duplicates, return the minimum element of this array.

You must decrease the overall operation steps as much as possible.',
  '[{"input":"nums = [1,3,5]","output":"1"},{"input":"nums = [2,2,2,0,1]","output":"0"}]'::jsonb,
  '["n == nums.length","1 <= n <= 5000","-5000 <= nums[i] <= 5000","nums is sorted and rotated between 1 and n times"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function findMin(nums) {\n  // Your code here\n}","python":"def findMin(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int findMin(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,3,5]","output":"1"},{"input":"[2,2,2,0,1]","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["Use binary search with special handling for duplicates.","If nums[mid] == nums[right], we can''t determine which half, so decrement right.","If nums[mid] > nums[right], minimum is in right half.","Otherwise, minimum is in left half (including mid)."]'::jsonb,
  43.2,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-running-time-computers',
  'Maximum Running Time of N Computers',
  'maximum-running-time-computers',
  'hard',
  'You have `n` computers. You are given the integer `n` and a 0-indexed integer array `batteries` where the `ith` battery can run a computer for `batteries[i]` minutes. You are interested in running all `n` computers simultaneously using the given batteries.

Initially, you can insert at most one battery into each computer. After that and at any integer time moment, you can remove a battery from a computer and insert another battery any number of times. The inserted battery can be a totally new battery or a battery from another computer. You may assume that the removing and inserting processes take no time.

Note that the batteries cannot be recharged.

Return the maximum number of minutes you can run all the `n` computers simultaneously.',
  '[{"input":"n = 2, batteries = [3,3,3]","output":"4","explanation":"Initially, insert battery 0 into the first computer and battery 1 into the second computer.\nAfter two minutes, remove battery 1 from the second computer and insert battery 2 instead. Note that battery 1 can still run for one minute.\nAt the end of the third minute, battery 0 is drained, and you need to remove it from the first computer and insert battery 1 instead.\nBy the end of the fourth minute, battery 1 is also drained, and the first computer is no longer running.\nWe can run the two computers simultaneously for at most 4 minutes, so we return 4."},{"input":"n = 2, batteries = [1,1,1,1]","output":"2"}]'::jsonb,
  '["1 <= n <= batteries.length <= 10^5","1 <= batteries[i] <= 10^9"]'::jsonb,
  '["Array","Binary Search","Greedy","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function maxRunTime(n, batteries) {\n  // Your code here\n}","python":"def maxRunTime(n, batteries):\n    # Your code here\n    pass","java":"class Solution {\n    public long maxRunTime(int n, int[] batteries) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"2, [3,3,3]","output":"4"},{"input":"2, [1,1,1,1]","output":"2"}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on the running time.","For a given time t, check if total battery power >= n * t.","Cap each battery at t (excess can''t be used by one computer)."]'::jsonb,
  48.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimize-max-distance-gas-station',
  'Minimize Max Distance to Gas Station',
  'minimize-max-distance-gas-station',
  'hard',
  'You are given an integer array `stations` that represents the positions of the gas stations on the x-axis. You are also given an integer `k`.

You should add `k` new gas stations. You can add the stations anywhere on the x-axis, and not necessarily on an integer position.

Let `penalty()` be the maximum distance between adjacent gas stations after adding the `k` new stations.

Return the smallest possible value of `penalty()`. Answers within `10^-6` of the actual answer will be accepted.',
  '[{"input":"stations = [1,2,3,4,5,6,7,8,9,10], k = 9","output":"0.50000"},{"input":"stations = [23,24,36,39,46,56,57,65,84,98], k = 1","output":"14.00000"}]'::jsonb,
  '["10 <= stations.length <= 2000","0 <= stations[i] <= 10^8","stations is sorted in strictly increasing order","1 <= k <= 10^6"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function minmaxGasDist(stations, k) {\n  // Your code here\n}","python":"def minmaxGasDist(stations, k):\n    # Your code here\n    pass","java":"class Solution {\n    public double minmaxGasDist(int[] stations, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5,6,7,8,9,10], 9","output":"0.50000"},{"input":"[23,24,36,39,46,56,57,65,84,98], 1","output":"14.00000"}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on the answer (max distance).","For a given max distance, calculate how many stations needed.","For each gap, stations_needed = ceil(gap / max_dist) - 1.","Check if total needed <= k."]'::jsonb,
  51.4,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'divide-chocolate',
  'Divide Chocolate',
  'divide-chocolate',
  'hard',
  'You have one chocolate bar that consists of some chunks. Each chunk has its own sweetness given by the array `sweetness`.

You want to share the chocolate with your `k` friends so you start cutting the chocolate bar into `k + 1` pieces using `k` cuts, each piece consists of some consecutive chunks.

Being generous, you will eat the piece with the minimum total sweetness and give the other pieces to your friends.

Find the maximum total sweetness of the piece you can get by cutting the chocolate bar optimally.',
  '[{"input":"sweetness = [1,2,3,4,5,6,7,8,9], k = 5","output":"6","explanation":"You can divide the chocolate to [1,2,3], [4,5], [6], [7], [8], [9]"},{"input":"sweetness = [5,6,7,8,9,1,2,3,4], k = 8","output":"1","explanation":"There is only one way to cut the bar into 9 pieces."},{"input":"sweetness = [1,2,2,1,2,2,1,2,2], k = 2","output":"5","explanation":"You can divide the chocolate to [1,2,2], [1,2,2], [1,2,2]"}]'::jsonb,
  '["0 <= k < sweetness.length <= 10^4","1 <= sweetness[i] <= 10^5"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function maximizeSweetness(sweetness, k) {\n  // Your code here\n}","python":"def maximizeSweetness(sweetness, k):\n    # Your code here\n    pass","java":"class Solution {\n    public int maximizeSweetness(int[] sweetness, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5,6,7,8,9], 5","output":"6"},{"input":"[5,6,7,8,9,1,2,3,4], 8","output":"1"},{"input":"[1,2,2,1,2,2,1,2,2], 2","output":"5"}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on the answer (minimum sweetness).","For a given min sweetness, check if we can create k+1 pieces.","Greedily create pieces when accumulated sum >= min sweetness."]'::jsonb,
  58.3,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'partition-array-two-minimize-sum',
  'Partition Array Into Two Arrays to Minimize Sum Difference',
  'partition-array-two-minimize-sum',
  'hard',
  'You are given an integer array `nums` of `2 * n` integers. You need to partition `nums` into two arrays of length `n` to minimize the absolute difference of the sums of the arrays. To partition `nums`, put each element of `nums` into one of the two arrays.

Return the minimum possible absolute difference.',
  '[{"input":"nums = [3,9,7,3]","output":"2","explanation":"One optimal partition is: [3,9] and [7,3].\nThe absolute difference between the sums of the arrays is abs((3 + 9) - (7 + 3)) = 2."},{"input":"nums = [-36,36]","output":"72","explanation":"One optimal partition is: [-36] and [36].\nThe absolute difference between the sums of the arrays is abs((-36) - (36)) = 72."}]'::jsonb,
  '["1 <= n <= 15","nums.length == 2 * n","-10^7 <= nums[i] <= 10^7"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Dynamic Programming","Bit Manipulation","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumDifference(nums) {\n  // Your code here\n}","python":"def minimumDifference(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int minimumDifference(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[3,9,7,3]","output":"2"},{"input":"[-36,36]","output":"72"}]'::jsonb,
  '[]'::jsonb,
  '["Split array into two halves.","Generate all possible sums for each half with k elements.","Use binary search to find complement that minimizes difference.","Meet in the middle approach."]'::jsonb,
  35.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-flowers-full-bloom',
  'Number of Flowers in Full Bloom',
  'number-flowers-full-bloom',
  'hard',
  'You are given a 0-indexed 2D integer array `flowers`, where `flowers[i] = [starti, endi]` means the `ith` flower will be in full bloom from `starti` to `endi` (inclusive). You are also given a 0-indexed integer array `people` of size `n`, where `people[i]` is the time that the `ith` person will arrive to see the flowers.

Return an integer array `answer` of size `n`, where `answer[i]` is the number of flowers that are in full bloom when the `ith` person arrives.',
  '[{"input":"flowers = [[1,6],[3,7],[9,12],[4,13]], people = [2,3,7,11]","output":"[1,2,2,2]","explanation":"The figure above shows the times when the flowers are in full bloom and when the people arrive.\nFor each person, we return the number of flowers in full bloom during their arrival."},{"input":"flowers = [[1,10],[3,3]], people = [3,3,2]","output":"[2,2,1]"}]'::jsonb,
  '["1 <= flowers.length <= 5 * 10^4","flowers[i].length == 2","1 <= starti <= endi <= 10^9","1 <= people.length <= 5 * 10^4","1 <= people[i] <= 10^9"]'::jsonb,
  '["Array","Hash Table","Binary Search","Sorting","Prefix Sum","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"function fullBloomFlowers(flowers, people) {\n  // Your code here\n}","python":"def fullBloomFlowers(flowers, people):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] fullBloomFlowers(int[][] flowers, int[] people) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,6],[3,7],[9,12],[4,13]], [2,3,7,11]","output":"[1,2,2,2]"},{"input":"[[1,10],[3,3]], [3,3,2]","output":"[2,2,1]"}]'::jsonb,
  '[]'::jsonb,
  '["Create two sorted arrays: start times and end times.","For each person''s time t, binary search for:","  - Count of flowers that started <= t","  - Count of flowers that ended < t","Answer = started - ended"]'::jsonb,
  57.9,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'koko-eating-bananas',
  'Koko Eating Bananas',
  'koko-eating-bananas',
  'medium',
  'Koko loves to eat bananas. There are `n` piles of bananas, the `ith` pile has `piles[i]` bananas. The guards have gone and will come back in `h` hours.

Koko can decide her bananas-per-hour eating speed of `k`. Each hour, she chooses some pile of bananas and eats `k` bananas from that pile. If the pile has less than `k` bananas, she eats all of them instead and will not eat any more bananas during this hour.

Koko likes to eat slowly but still wants to finish eating all the bananas before the guards return.

Return the minimum integer `k` such that she can eat all the bananas within `h` hours.',
  '[{"input":"piles = [3,6,7,11], h = 8","output":"4"},{"input":"piles = [30,11,23,4,20], h = 5","output":"30"},{"input":"piles = [30,11,23,4,20], h = 6","output":"23"}]'::jsonb,
  '["1 <= piles.length <= 10^4","piles.length <= h <= 10^9","1 <= piles[i] <= 10^9"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function minEatingSpeed(piles, h) {\n  // Your code here\n}","python":"def minEatingSpeed(piles, h):\n    # Your code here\n    pass","java":"class Solution {\n    public int minEatingSpeed(int[] piles, int h) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[3,6,7,11], 8","output":"4"},{"input":"[30,11,23,4,20], 5","output":"30"},{"input":"[30,11,23,4,20], 6","output":"23"}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on eating speed k from 1 to max(piles).","For each speed, calculate hours needed: sum of ceil(pile/k).","Find minimum k where hours <= h."]'::jsonb,
  55.8,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'search-rotated-sorted-array-ii',
  'Search in Rotated Sorted Array II',
  'search-rotated-sorted-array-ii',
  'medium',
  'There is an integer array `nums` sorted in non-decreasing order (not necessarily with distinct values).

Before being passed to your function, `nums` is rotated at an unknown pivot index `k` (`0 <= k < nums.length`) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (0-indexed). For example, `[0,1,2,4,4,4,5,6,6,7]` might be rotated at pivot index `5` and become `[4,5,6,6,7,0,1,2,4,4]`.

Given the array `nums` after the rotation and an integer `target`, return `true` if `target` is in `nums`, or `false` if it is not in `nums`.

You must decrease the overall operation steps as much as possible.',
  '[{"input":"nums = [2,5,6,0,0,1,2], target = 0","output":"true"},{"input":"nums = [2,5,6,0,0,1,2], target = 3","output":"false"}]'::jsonb,
  '["1 <= nums.length <= 5000","-10^4 <= nums[i] <= 10^4","nums is guaranteed to be rotated at some pivot","-10^4 <= target <= 10^4"]'::jsonb,
  '["Array","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function search(nums, target) {\n  // Your code here\n}","python":"def search(nums, target):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean search(int[] nums, int target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,5,6,0,0,1,2], 0","output":"true"},{"input":"[2,5,6,0,0,1,2], 3","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Similar to Search in Rotated Sorted Array but with duplicates.","When nums[left] == nums[mid] == nums[right], increment left and decrement right.","Otherwise, determine which half is sorted and check if target is in range."]'::jsonb,
  36.8,
  '["Amazon","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'subsets-78',
  'Subsets',
  'subsets-78',
  'medium',
  'Given an integer array `nums` of unique elements, return all possible subsets (the power set).

The solution set must not contain duplicate subsets. Return the solution in any order.',
  '[{"input":"nums = [1,2,3]","output":"[[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]"},{"input":"nums = [0]","output":"[[],[0]]"}]'::jsonb,
  '["1 <= nums.length <= 10","-10 <= nums[i] <= 10","All the numbers of nums are unique"]'::jsonb,
  '["Array","Backtracking","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function subsets(nums) {\n  // Your code here\n}","python":"def subsets(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> subsets(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3]","output":"[[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]"},{"input":"[0]","output":"[[],[0]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking to generate all subsets.","For each element, you have two choices: include it or exclude it.","Alternative: Use bit manipulation - each subset corresponds to a bitmask.","Start with empty subset and iteratively add elements."]'::jsonb,
  75.8,
  '["Amazon","Facebook","Google","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'permutations',
  'Permutations',
  'permutations',
  'medium',
  'Given an array `nums` of distinct integers, return all the possible permutations. You can return the answer in any order.',
  '[{"input":"nums = [1,2,3]","output":"[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]"},{"input":"nums = [0,1]","output":"[[0,1],[1,0]]"},{"input":"nums = [1]","output":"[[1]]"}]'::jsonb,
  '["1 <= nums.length <= 6","-10 <= nums[i] <= 10","All the integers of nums are unique"]'::jsonb,
  '["Array","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function permute(nums) {\n  // Your code here\n}","python":"def permute(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> permute(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3]","output":"[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]"},{"input":"[0,1]","output":"[[0,1],[1,0]]"},{"input":"[1]","output":"[[1]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with a visited/used array.","For each position, try every unused number.","When current permutation length equals n, add to result.","Alternative: Swap elements in place to generate permutations."]'::jsonb,
  76.4,
  '["Amazon","Microsoft","Facebook","LinkedIn","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'letter-combinations-phone',
  'Letter Combinations of a Phone Number',
  'letter-combinations-phone',
  'medium',
  'Given a string containing digits from `2-9` inclusive, return all possible letter combinations that the number could represent. Return the answer in any order.

A mapping of digits to letters (just like on the telephone buttons) is given below. Note that 1 does not map to any letters.

2: abc
3: def
4: ghi
5: jkl
6: mno
7: pqrs
8: tuv
9: wxyz',
  '[{"input":"digits = \"23\"","output":"[\"ad\",\"ae\",\"af\",\"bd\",\"be\",\"bf\",\"cd\",\"ce\",\"cf\"]"},{"input":"digits = \"\"","output":"[]"},{"input":"digits = \"2\"","output":"[\"a\",\"b\",\"c\"]"}]'::jsonb,
  '["0 <= digits.length <= 4","digits[i] is a digit in the range [''2'', ''9'']"]'::jsonb,
  '["Hash Table","String","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function letterCombinations(digits) {\n  // Your code here\n}","python":"def letterCombinations(digits):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> letterCombinations(String digits) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"23\"","output":"[\"ad\",\"ae\",\"af\",\"bd\",\"be\",\"bf\",\"cd\",\"ce\",\"cf\"]"},{"input":"\"\"","output":"[]"},{"input":"\"2\"","output":"[\"a\",\"b\",\"c\"]"}]'::jsonb,
  '[]'::jsonb,
  '["Create a map from digit to letters.","Use backtracking to build combinations character by character.","For each digit, try all its corresponding letters.","Base case: when current combination length equals digits length."]'::jsonb,
  57.9,
  '["Amazon","Facebook","Google","Microsoft","Uber"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'generate-parentheses',
  'Generate Parentheses',
  'generate-parentheses',
  'medium',
  'Given `n` pairs of parentheses, write a function to generate all combinations of well-formed parentheses.',
  '[{"input":"n = 3","output":"[\"((()))\",\"(()())\",\"(())()\",\"()(())\",\"()()()\"]"},{"input":"n = 1","output":"[\"()\"]"}]'::jsonb,
  '["1 <= n <= 8"]'::jsonb,
  '["String","Dynamic Programming","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function generateParenthesis(n) {\n  // Your code here\n}","python":"def generateParenthesis(n):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> generateParenthesis(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"3","output":"[\"((()))\",\"(()())\",\"(())()\",\"()(())\",\"()()()\"]"},{"input":"1","output":"[\"()\"]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with two counters: open and close.","Can add ''('' if open < n.","Can add '')'' if close < open.","Add to result when both counters equal n."]'::jsonb,
  73.8,
  '["Amazon","Google","Facebook","Microsoft","Uber"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'letter-case-permutation',
  'Letter Case Permutation',
  'letter-case-permutation',
  'medium',
  'Given a string `s`, you can transform every letter individually to be lowercase or uppercase to create another string.

Return a list of all possible strings we could create. Return the output in any order.',
  '[{"input":"s = \"a1b2\"","output":"[\"a1b2\",\"a1B2\",\"A1b2\",\"A1B2\"]"},{"input":"s = \"3z4\"","output":"[\"3z4\",\"3Z4\"]"}]'::jsonb,
  '["1 <= s.length <= 12","s consists of lowercase English letters, uppercase English letters, and digits"]'::jsonb,
  '["String","Backtracking","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function letterCasePermutation(s) {\n  // Your code here\n}","python":"def letterCasePermutation(s):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> letterCasePermutation(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"a1b2\"","output":"[\"a1b2\",\"a1B2\",\"A1b2\",\"A1B2\"]"},{"input":"\"3z4\"","output":"[\"3z4\",\"3Z4\"]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking to explore both cases for letters.","For digits, just add them as is.","For letters, try both lowercase and uppercase.","Alternative: Use BFS, starting with original string and branching at each letter."]'::jsonb,
  74.2,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'letter-tile-possibilities',
  'Letter Tile Possibilities',
  'letter-tile-possibilities',
  'medium',
  'You have `n` tiles, where each tile has one letter `tiles[i]` printed on it.

Return the number of possible non-empty sequences of letters you can make using the letters printed on those tiles.',
  '[{"input":"tiles = \"AAB\"","output":"8","explanation":"The possible sequences are \"A\", \"B\", \"AA\", \"AB\", \"BA\", \"AAB\", \"ABA\", \"BAA\"."},{"input":"tiles = \"AAABBC\"","output":"188"},{"input":"tiles = \"V\"","output":"1"}]'::jsonb,
  '["1 <= tiles.length <= 7","tiles consists of uppercase English letters"]'::jsonb,
  '["String","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function numTilePossibilities(tiles) {\n  // Your code here\n}","python":"def numTilePossibilities(tiles):\n    # Your code here\n    pass","java":"class Solution {\n    public int numTilePossibilities(String tiles) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"AAB\"","output":"8"},{"input":"\"AAABBC\"","output":"188"},{"input":"\"V\"","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with frequency map to avoid duplicates.","For each position, try each available letter.","Count each valid sequence (empty sequence excluded).","Use frequency array to track available letters."]'::jsonb,
  76.9,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'partition-k-equal-sum',
  'Partition to K Equal Sum Subsets',
  'partition-k-equal-sum',
  'medium',
  'Given an integer array `nums` and an integer `k`, return `true` if it is possible to divide this array into `k` non-empty subsets whose sums are all equal.',
  '[{"input":"nums = [4,3,2,3,5,2,1], k = 4","output":"true","explanation":"It is possible to divide it into 4 subsets (5), (1, 4), (2,3), (2,3) with equal sums."},{"input":"nums = [1,2,3,4], k = 3","output":"false"}]'::jsonb,
  '["1 <= k <= nums.length <= 16","1 <= nums[i] <= 10^4","The frequency of each element is in the range [1, 4]"]'::jsonb,
  '["Array","Dynamic Programming","Backtracking","Bit Manipulation","Memoization","Bitmask"]'::jsonb,
  'DSA',
  '{"javascript":"function canPartitionKSubsets(nums, k) {\n  // Your code here\n}","python":"def canPartitionKSubsets(nums, k):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean canPartitionKSubsets(int[] nums, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[4,3,2,3,5,2,1], 4","output":"true"},{"input":"[1,2,3,4], 3","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Calculate target sum = total_sum / k. If not divisible, return false.","Sort array in descending order for optimization.","Use backtracking to try assigning each number to k buckets.","Track current sum of each bucket and use visited array.","Alternative: Use bitmask DP for optimization."]'::jsonb,
  45.7,
  '["Amazon","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-swap',
  'Maximum Swap',
  'maximum-swap',
  'medium',
  'You are given an integer `num`. You can swap two digits at most once to get the maximum valued number.

Return the maximum valued number you can get.',
  '[{"input":"num = 2736","output":"7236","explanation":"Swap the number 2 and the number 7."},{"input":"num = 9973","output":"9973","explanation":"No swap."}]'::jsonb,
  '["0 <= num <= 10^8"]'::jsonb,
  '["Math","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function maximumSwap(num) {\n  // Your code here\n}","python":"def maximumSwap(num):\n    # Your code here\n    pass","java":"class Solution {\n    public int maximumSwap(int num) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"2736","output":"7236"},{"input":"9973","output":"9973"}]'::jsonb,
  '[]'::jsonb,
  '["Convert number to array of digits.","For each position, find the maximum digit to its right.","Swap with the rightmost occurrence of the maximum digit that''s greater than current.","Return after first swap."]'::jsonb,
  47.8,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'can-place-flowers',
  'Can Place Flowers',
  'can-place-flowers',
  'easy',
  'You have a long flowerbed in which some of the plots are planted, and some are not. However, flowers cannot be planted in adjacent plots.

Given an integer array `flowerbed` containing `0`''s and `1`''s, where `0` means empty and `1` means not empty, and an integer `n`, return `true` if `n` new flowers can be planted in the `flowerbed` without violating the no-adjacent-flowers rule and `false` otherwise.',
  '[{"input":"flowerbed = [1,0,0,0,1], n = 1","output":"true"},{"input":"flowerbed = [1,0,0,0,1], n = 2","output":"false"}]'::jsonb,
  '["1 <= flowerbed.length <= 2 * 10^4","flowerbed[i] is 0 or 1","There are no two adjacent flowers in flowerbed","0 <= n <= flowerbed.length"]'::jsonb,
  '["Array","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function canPlaceFlowers(flowerbed, n) {\n  // Your code here\n}","python":"def canPlaceFlowers(flowerbed, n):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean canPlaceFlowers(int[] flowerbed, int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,0,0,0,1], 1","output":"true"},{"input":"[1,0,0,0,1], 2","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Greedily plant flowers from left to right.","Can plant at position i if: flowerbed[i] == 0 && (i == 0 || flowerbed[i-1] == 0) && (i == n-1 || flowerbed[i+1] == 0).","Count planted flowers and compare with n."]'::jsonb,
  33.2,
  '["LinkedIn","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'largest-odd-number-string',
  'Largest Odd Number in String',
  'largest-odd-number-string',
  'easy',
  'You are given a string `num`, representing a large integer. Return the largest-valued odd integer (as a string) that is a non-empty substring of `num`, or an empty string `""` if no odd integer exists.

A substring is a contiguous sequence of characters within a string.',
  '[{"input":"num = \"52\"","output":"\"5\"","explanation":"The only non-empty substrings are \"5\", \"2\", and \"52\". \"5\" is the only odd number."},{"input":"num = \"4206\"","output":"\"\"","explanation":"There are no odd numbers in \"4206\"."},{"input":"num = \"35427\"","output":"\"35427\"","explanation":"\"35427\" is already an odd number."}]'::jsonb,
  '["1 <= num.length <= 10^5","num only consists of digits and does not contain any leading zeros"]'::jsonb,
  '["Math","String","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function largestOddNumber(num) {\n  // Your code here\n}","python":"def largestOddNumber(num):\n    # Your code here\n    pass","java":"class Solution {\n    public String largestOddNumber(String num) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"52\"","output":"\"5\""},{"input":"\"4206\"","output":"\"\""},{"input":"\"35427\"","output":"\"35427\""}]'::jsonb,
  '[]'::jsonb,
  '["A number is odd if its last digit is odd.","Find the rightmost odd digit.","Return substring from 0 to that position (inclusive)."]'::jsonb,
  59.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'candy',
  'Candy',
  'candy',
  'hard',
  'There are `n` children standing in a line. Each child is assigned a rating value given in the integer array `ratings`.

You are giving candies to these children subjected to the following requirements:
- Each child must have at least one candy.
- Children with a higher rating get more candies than their neighbors.

Return the minimum number of candies you need to have to distribute the candies to the children.',
  '[{"input":"ratings = [1,0,2]","output":"5","explanation":"You can allocate to the first, second and third child with 2, 1, 2 candies respectively."},{"input":"ratings = [1,2,2]","output":"4","explanation":"You can allocate to the first, second and third child with 1, 2, 1 candies respectively.\nThe third child gets 1 candy because it satisfies the above two conditions."}]'::jsonb,
  '["n == ratings.length","1 <= n <= 2 * 10^4","0 <= ratings[i] <= 2 * 10^4"]'::jsonb,
  '["Array","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function candy(ratings) {\n  // Your code here\n}","python":"def candy(ratings):\n    # Your code here\n    pass","java":"class Solution {\n    public int candy(int[] ratings) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,0,2]","output":"5"},{"input":"[1,2,2]","output":"4"}]'::jsonb,
  '[]'::jsonb,
  '["Two pass approach: left to right, then right to left.","First pass: if ratings[i] > ratings[i-1], candies[i] = candies[i-1] + 1.","Second pass: if ratings[i] > ratings[i+1], candies[i] = max(candies[i], candies[i+1] + 1).","Sum all candies."]'::jsonb,
  40.3,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-replacements-sort',
  'Minimum Replacements to Sort the Array',
  'minimum-replacements-sort',
  'hard',
  'You are given a 0-indexed integer array `nums`. In one operation you can replace any element of the array with any two elements that sum to it.

Return the minimum number of operations to make the array sorted in non-decreasing order.',
  '[{"input":"nums = [3,9,3]","output":"2","explanation":"Here are the steps to sort the array in non-decreasing order:\n- From [3,9,3], replace the 9 with 3 and 6 so the array becomes [3,3,6,3]\n- From [3,3,6,3], replace the 6 with 3 and 3 so the array becomes [3,3,3,3,3]"},{"input":"nums = [1,2,3,4,5]","output":"0","explanation":"The array is already in non-decreasing order, so we do not need any operations."}]'::jsonb,
  '["1 <= nums.length <= 10^5","1 <= nums[i] <= 10^9"]'::jsonb,
  '["Array","Math","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumReplacement(nums) {\n  // Your code here\n}","python":"def minimumReplacement(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public long minimumReplacement(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[3,9,3]","output":"2"},{"input":"[1,2,3,4,5]","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["Process from right to left.","Keep track of the maximum allowed value (initially nums[n-1]).","For each element larger than max, split it optimally.","Operations = ceil(nums[i] / max) - 1, new max = nums[i] / ceil(nums[i] / max)."]'::jsonb,
  43.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'jump-game-ii',
  'Jump Game II',
  'jump-game-ii',
  'medium',
  'You are given a 0-indexed array of integers `nums` of length `n`. You are initially positioned at `nums[0]`.

Each element `nums[i]` represents the maximum length of a forward jump from index `i`. In other words, if you are at `nums[i]`, you can jump to any `nums[i + j]` where:
- `0 <= j <= nums[i]` and
- `i + j < n`

Return the minimum number of jumps to reach `nums[n - 1]`. The test cases are generated such that you can reach `nums[n - 1]`.',
  '[{"input":"nums = [2,3,1,1,4]","output":"2","explanation":"The minimum number of jumps to reach the last index is 2. Jump 1 step from index 0 to 1, then 3 steps to the last index."},{"input":"nums = [2,3,0,1,4]","output":"2"}]'::jsonb,
  '["1 <= nums.length <= 10^4","0 <= nums[i] <= 1000","It''s guaranteed that you can reach nums[n - 1]"]'::jsonb,
  '["Array","Dynamic Programming","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function jump(nums) {\n  // Your code here\n}","python":"def jump(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int jump(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,3,1,1,4]","output":"2"},{"input":"[2,3,0,1,4]","output":"2"}]'::jsonb,
  '[]'::jsonb,
  '["Use greedy approach with BFS-like logic.","Track current jump''s end and farthest reachable position.","When reaching current end, increment jumps and update end to farthest.","No need to jump from last position."]'::jsonb,
  40.1,
  '["Amazon","Microsoft","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'best-time-buy-sell-stock',
  'Best Time to Buy and Sell Stock',
  'best-time-buy-sell-stock',
  'easy',
  'You are given an array `prices` where `prices[i]` is the price of a given stock on the `ith` day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return `0`.',
  '[{"input":"prices = [7,1,5,3,6,4]","output":"5","explanation":"Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.\nNote that buying on day 2 and selling on day 1 is not allowed because you must buy before you sell."},{"input":"prices = [7,6,4,3,1]","output":"0","explanation":"In this case, no transactions are done and the max profit = 0."}]'::jsonb,
  '["1 <= prices.length <= 10^5","0 <= prices[i] <= 10^4"]'::jsonb,
  '["Array","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function maxProfit(prices) {\n  // Your code here\n}","python":"def maxProfit(prices):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxProfit(int[] prices) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[7,1,5,3,6,4]","output":"5"},{"input":"[7,6,4,3,1]","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["Track minimum price seen so far.","For each price, calculate profit if selling today.","Update maximum profit.","One pass solution with O(1) space."]'::jsonb,
  54.2,
  '["Amazon","Facebook","Microsoft","Bloomberg","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'jump-game',
  'Jump Game',
  'jump-game',
  'medium',
  'You are given an integer array `nums`. You are initially positioned at the array''s first index, and each element in the array represents your maximum jump length at that position.

Return `true` if you can reach the last index, or `false` otherwise.',
  '[{"input":"nums = [2,3,1,1,4]","output":"true","explanation":"Jump 1 step from index 0 to 1, then 3 steps to the last index."},{"input":"nums = [3,2,1,0,4]","output":"false","explanation":"You will always arrive at index 3 no matter what. Its maximum jump length is 0, which makes it impossible to reach the last index."}]'::jsonb,
  '["1 <= nums.length <= 10^4","0 <= nums[i] <= 10^5"]'::jsonb,
  '["Array","Dynamic Programming","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function canJump(nums) {\n  // Your code here\n}","python":"def canJump(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean canJump(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,3,1,1,4]","output":"true"},{"input":"[3,2,1,0,4]","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Track the farthest position reachable.","Iterate through array and update farthest = max(farthest, i + nums[i]).","If current index > farthest, return false.","If farthest >= last index, return true."]'::jsonb,
  38.7,
  '["Amazon","Microsoft","Google","Adobe"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'boats-to-save-people',
  'Boats to Save People',
  'boats-to-save-people',
  'medium',
  'You are given an array `people` where `people[i]` is the weight of the `ith` person, and an infinite number of boats where each boat can carry a maximum weight of `limit`. Each boat carries at most two people at the same time, provided the sum of the weight of those people is at most `limit`.

Return the minimum number of boats to carry every given person.',
  '[{"input":"people = [1,2], limit = 3","output":"1","explanation":"1 boat (1, 2)"},{"input":"people = [3,2,2,1], limit = 3","output":"3","explanation":"3 boats (1, 2), (2) and (3)"},{"input":"people = [3,5,3,4], limit = 5","output":"4","explanation":"4 boats (3), (3), (4), (5)"}]'::jsonb,
  '["1 <= people.length <= 5 * 10^4","1 <= people[i] <= limit <= 3 * 10^4"]'::jsonb,
  '["Array","Two Pointers","Greedy","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function numRescueBoats(people, limit) {\n  // Your code here\n}","python":"def numRescueBoats(people, limit):\n    # Your code here\n    pass","java":"class Solution {\n    public int numRescueBoats(int[] people, int limit) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2], 3","output":"1"},{"input":"[3,2,2,1], 3","output":"3"},{"input":"[3,5,3,4], 5","output":"4"}]'::jsonb,
  '[]'::jsonb,
  '["Sort the array.","Use two pointers: lightest and heaviest person.","If they can share a boat (sum <= limit), move both pointers.","Otherwise, heaviest takes a boat alone.","Count boats used."]'::jsonb,
  53.2,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'gas-station',
  'Gas Station',
  'gas-station',
  'medium',
  'There are `n` gas stations along a circular route, where the amount of gas at the `ith` station is `gas[i]`.

You have a car with an unlimited gas tank and it costs `cost[i]` of gas to travel from the `ith` station to its next `(i + 1)th` station. You begin the journey with an empty tank at one of the gas stations.

Given two integer arrays `gas` and `cost`, return the starting gas station''s index if you can travel around the circuit once in the clockwise direction, otherwise return `-1`. If there exists a solution, it is guaranteed to be unique.',
  '[{"input":"gas = [1,2,3,4,5], cost = [3,4,5,1,2]","output":"3","explanation":"Start at station 3 (index 3) and fill up with 4 unit of gas. Your tank = 0 + 4 = 4\nTravel to station 4. Your tank = 4 - 1 + 5 = 8\nTravel to station 0. Your tank = 8 - 2 + 1 = 7\nTravel to station 1. Your tank = 7 - 3 + 2 = 6\nTravel to station 2. Your tank = 6 - 4 + 3 = 5\nTravel to station 3. The cost is 5. Your gas is just enough to travel back to station 3.\nTherefore, return 3 as the starting index."},{"input":"gas = [2,3,4], cost = [3,4,3]","output":"-1","explanation":"You can''t start at station 0 or 1, as there is not enough gas to travel to the next station.\nLet''s start at station 2 and fill up with 4 unit of gas. Your tank = 0 + 4 = 4\nTravel to station 0. Your tank = 4 - 3 + 2 = 3\nTravel to station 1. Your tank = 3 - 3 + 3 = 3\nYou cannot travel back to station 2, as it requires 4 unit of gas but you only have 3.\nTherefore, you can''t travel around the circuit once no matter where you start."}]'::jsonb,
  '["n == gas.length == cost.length","1 <= n <= 10^5","0 <= gas[i], cost[i] <= 10^4"]'::jsonb,
  '["Array","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function canCompleteCircuit(gas, cost) {\n  // Your code here\n}","python":"def canCompleteCircuit(gas, cost):\n    # Your code here\n    pass","java":"class Solution {\n    public int canCompleteCircuit(int[] gas, int[] cost) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,4,5], [3,4,5,1,2]","output":"3"},{"input":"[2,3,4], [3,4,3]","output":"-1"}]'::jsonb,
  '[]'::jsonb,
  '["If total gas < total cost, impossible.","Track current tank and total tank.","If current tank < 0 at position i, previous start positions won''t work.","Set new start to i+1 and reset current tank."]'::jsonb,
  45.8,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'two-city-scheduling',
  'Two City Scheduling',
  'two-city-scheduling',
  'medium',
  'A company is planning to interview `2n` people. Given the array `costs` where `costs[i] = [aCosti, bCosti]`, the cost of flying the `ith` person to city `a` is `aCosti`, and the cost of flying the `ith` person to city `b` is `bCosti`.

Return the minimum cost to fly every person to a city such that exactly `n` people arrive in each city.',
  '[{"input":"costs = [[10,20],[30,200],[400,50],[30,20]]","output":"110","explanation":"The first person goes to city A for a cost of 10.\nThe second person goes to city A for a cost of 30.\nThe third person goes to city B for a cost of 50.\nThe fourth person goes to city B for a cost of 20.\nThe total minimum cost is 10 + 30 + 50 + 20 = 110 to have half the people interviewing in each city."},{"input":"costs = [[259,770],[448,54],[926,667],[184,139],[840,118],[577,469]]","output":"1859"}]'::jsonb,
  '["2 * n == costs.length","2 <= costs.length <= 100","costs.length is even","1 <= aCosti, bCosti <= 1000"]'::jsonb,
  '["Array","Greedy","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function twoCitySchedCost(costs) {\n  // Your code here\n}","python":"def twoCitySchedCost(costs):\n    # Your code here\n    pass","java":"class Solution {\n    public int twoCitySchedCost(int[][] costs) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[10,20],[30,200],[400,50],[30,20]]","output":"110"},{"input":"[[259,770],[448,54],[926,667],[184,139],[840,118],[577,469]]","output":"1859"}]'::jsonb,
  '[]'::jsonb,
  '["Send everyone to city A first.","Sort by the difference (costA - costB).","Send first n people to A (they benefit most from A).","Refund the difference for last n people and send them to B."]'::jsonb,
  64.2,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-refueling-stops',
  'Minimum Number of Refueling Stops',
  'minimum-refueling-stops',
  'hard',
  'A car travels from a starting position to a destination which is `target` miles east of the starting position.

There are gas stations along the way. The gas stations are represented as an array `stations` where `stations[i] = [positioni, fueli]` indicates that the `ith` gas station is `positioni` miles east of the starting position and has `fueli` liters of gas.

The car starts with an infinite tank and `startFuel` liters of fuel in it. It uses one liter of fuel per one mile that it drives. When the car reaches a gas station, it may stop and refuel, transferring all the gas from the station into the car.

Return the minimum number of refueling stops the car must make in order to reach its destination. If it cannot reach the destination, return `-1`.

Note that if the car reaches a gas station with `0` fuel left, the car can still refuel there. If the car reaches the destination with `0` fuel left, it is still considered to have arrived.',
  '[{"input":"target = 1, startFuel = 1, stations = []","output":"0","explanation":"We can reach the target without refueling."},{"input":"target = 100, startFuel = 1, stations = [[10,100]]","output":"-1","explanation":"We can not reach the target (or even the first gas station)."},{"input":"target = 100, startFuel = 10, stations = [[10,60],[20,30],[30,30],[60,40]]","output":"2","explanation":"We start with 10 liters of fuel.\nWe drive to position 10, expending 10 liters of fuel. We refuel from 0 liters to 60 liters of gas.\nThen, we drive from position 10 to position 60 (expending 50 liters of fuel),\nand refuel from 10 liters to 50 liters of gas. We then drive to and reach the target.\nWe made 2 refueling stops along the way, so we return 2."}]'::jsonb,
  '["1 <= target, startFuel <= 10^9","0 <= stations.length <= 500","1 <= positioni < positioni+1 < target","1 <= fueli < 10^9"]'::jsonb,
  '["Array","Dynamic Programming","Greedy","Heap"]'::jsonb,
  'DSA',
  '{"javascript":"function minRefuelStops(target, startFuel, stations) {\n  // Your code here\n}","python":"def minRefuelStops(target, startFuel, stations):\n    # Your code here\n    pass","java":"class Solution {\n    public int minRefuelStops(int target, int startFuel, int[][] stations) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"1, 1, []","output":"0"},{"input":"100, 1, [[10,100]]","output":"-1"},{"input":"100, 10, [[10,60],[20,30],[30,30],[60,40]]","output":"2"}]'::jsonb,
  '[]'::jsonb,
  '["Use max heap to store fuel amounts of reachable stations.","Greedily pick stations with most fuel when needed.","Track current position and fuel.","Add passed stations to heap, refuel from heap when needed."]'::jsonb,
  39.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'best-time-buy-sell-stock-ii',
  'Best Time to Buy and Sell Stock II',
  'best-time-buy-sell-stock-ii',
  'medium',
  'You are given an integer array `prices` where `prices[i]` is the price of a given stock on the `ith` day.

On each day, you may decide to buy and/or sell the stock. You can only hold at most one share of the stock at any time. However, you can buy it then immediately sell it on the same day.

Find and return the maximum profit you can achieve.',
  '[{"input":"prices = [7,1,5,3,6,4]","output":"7","explanation":"Buy on day 2 (price = 1) and sell on day 3 (price = 5), profit = 5-1 = 4.\nThen buy on day 4 (price = 3) and sell on day 5 (price = 6), profit = 6-3 = 3.\nTotal profit is 4 + 3 = 7."},{"input":"prices = [1,2,3,4,5]","output":"4","explanation":"Buy on day 1 (price = 1) and sell on day 5 (price = 5), profit = 5-1 = 4.\nTotal profit is 4."},{"input":"prices = [7,6,4,3,1]","output":"0","explanation":"There is no way to make a positive profit, so we never buy the stock to achieve the maximum profit of 0."}]'::jsonb,
  '["1 <= prices.length <= 3 * 10^4","0 <= prices[i] <= 10^4"]'::jsonb,
  '["Array","Dynamic Programming","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function maxProfit(prices) {\n  // Your code here\n}","python":"def maxProfit(prices):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxProfit(int[] prices) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[7,1,5,3,6,4]","output":"7"},{"input":"[1,2,3,4,5]","output":"4"},{"input":"[7,6,4,3,1]","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["Collect all positive differences.","Whenever prices[i] > prices[i-1], add the difference to profit.","This captures all upward trends.","Simple greedy approach, O(n) time."]'::jsonb,
  64.8,
  '["Amazon","Bloomberg","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'n-queens-ii',
  'N-Queens II',
  'n-queens-ii',
  'hard',
  'The n-queens puzzle is the problem of placing `n` queens on an `n x n` chessboard such that no two queens attack each other.

Given an integer `n`, return the number of distinct solutions to the n-queens puzzle.',
  '[{"input":"n = 4","output":"2","explanation":"There are two distinct solutions to the 4-queens puzzle as shown."},{"input":"n = 1","output":"1"}]'::jsonb,
  '["1 <= n <= 9"]'::jsonb,
  '["Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function totalNQueens(n) {\n  // Your code here\n}","python":"def totalNQueens(n):\n    # Your code here\n    pass","java":"class Solution {\n    public int totalNQueens(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"4","output":"2"},{"input":"1","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking to place queens row by row.","Track columns, diagonals, and anti-diagonals using sets.","For position (row, col): diagonal = row - col, anti-diagonal = row + col.","Count valid complete placements."]'::jsonb,
  71.2,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'word-search',
  'Word Search',
  'word-search',
  'medium',
  'Given an `m x n` grid of characters `board` and a string `word`, return `true` if `word` exists in the grid.

The word can be constructed from letters of sequentially adjacent cells, where adjacent cells are horizontally or vertically neighboring. The same letter cell may not be used more than once.',
  '[{"input":"board = [[\"A\",\"B\",\"C\",\"E\"],[\"S\",\"F\",\"C\",\"S\"],[\"A\",\"D\",\"E\",\"E\"]], word = \"ABCCED\"","output":"true"},{"input":"board = [[\"A\",\"B\",\"C\",\"E\"],[\"S\",\"F\",\"C\",\"S\"],[\"A\",\"D\",\"E\",\"E\"]], word = \"SEE\"","output":"true"},{"input":"board = [[\"A\",\"B\",\"C\",\"E\"],[\"S\",\"F\",\"C\",\"S\"],[\"A\",\"D\",\"E\",\"E\"]], word = \"ABCB\"","output":"false"}]'::jsonb,
  '["m == board.length","n == board[i].length","1 <= m, n <= 6","1 <= word.length <= 15","board and word consists of only lowercase and uppercase English letters"]'::jsonb,
  '["Array","String","Backtracking","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function exist(board, word) {\n  // Your code here\n}","python":"def exist(board, word):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean exist(char[][] board, String word) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[\"A\",\"B\",\"C\",\"E\"],[\"S\",\"F\",\"C\",\"S\"],[\"A\",\"D\",\"E\",\"E\"]], \"ABCCED\"","output":"true"},{"input":"[[\"A\",\"B\",\"C\",\"E\"],[\"S\",\"F\",\"C\",\"S\"],[\"A\",\"D\",\"E\",\"E\"]], \"SEE\"","output":"true"},{"input":"[[\"A\",\"B\",\"C\",\"E\"],[\"S\",\"F\",\"C\",\"S\"],[\"A\",\"D\",\"E\",\"E\"]], \"ABCB\"","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Use DFS backtracking from each cell.","Mark visited cells temporarily.","Try all 4 directions (up, down, left, right).","Backtrack by unmarking visited cells."]'::jsonb,
  40.8,
  '["Amazon","Microsoft","Facebook","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'house-robber-iii',
  'House Robber III',
  'house-robber-iii',
  'medium',
  'The thief has found himself a new place for his thievery again. There is only one entrance to this area, called `root`.

Besides the `root`, each house has one and only one parent house. After a tour, the smart thief realized that all houses in this place form a binary tree. It will automatically contact the police if two directly-linked houses were broken into on the same night.

Given the `root` of the binary tree, return the maximum amount of money the thief can rob without alerting the police.',
  '[{"input":"root = [3,2,3,null,3,null,1]","output":"7","explanation":"Maximum amount of money the thief can rob = 3 + 3 + 1 = 7."},{"input":"root = [3,4,5,1,3,null,1]","output":"9","explanation":"Maximum amount of money the thief can rob = 4 + 5 = 9."}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 10^4]","0 <= Node.val <= 10^4"]'::jsonb,
  '["Dynamic Programming","Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function rob(root) {\n  // Your code here\n}","python":"def rob(root):\n    # Your code here\n    pass","java":"class Solution {\n    public int rob(TreeNode root) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[3,2,3,null,3,null,1]","output":"7"},{"input":"[3,4,5,1,3,null,1]","output":"9"}]'::jsonb,
  '[]'::jsonb,
  '["Use DFS with memoization or return pair (rob, not_rob).","For each node, calculate: max if we rob it vs don''t rob it.","If rob current: add value + don''t rob children.","If don''t rob current: max(rob or don''t rob) for each child."]'::jsonb,
  55.3,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'restore-ip-addresses',
  'Restore IP Addresses',
  'restore-ip-addresses',
  'medium',
  'A valid IP address consists of exactly four integers separated by single dots. Each integer is between `0` and `255` (inclusive) and cannot have leading zeros.

For example, `"0.1.2.201"` and `"192.168.1.1"` are valid IP addresses, but `"0.011.255.245"`, `"192.168.1.312"` and `"192.168@1.1"` are invalid IP addresses.

Given a string `s` containing only digits, return all possible valid IP addresses that can be formed by inserting dots into `s`. You are not allowed to reorder or remove any digits in `s`. You may return the valid IP addresses in any order.',
  '[{"input":"s = \"25525511135\"","output":"[\"255.255.11.135\",\"255.255.111.35\"]"},{"input":"s = \"0000\"","output":"[\"0.0.0.0\"]"},{"input":"s = \"101023\"","output":"[\"1.0.10.23\",\"1.0.102.3\",\"10.1.0.23\",\"10.10.2.3\",\"101.0.2.3\"]"}]'::jsonb,
  '["1 <= s.length <= 20","s consists of digits only"]'::jsonb,
  '["String","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function restoreIpAddresses(s) {\n  // Your code here\n}","python":"def restoreIpAddresses(s):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> restoreIpAddresses(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"25525511135\"","output":"[\"255.255.11.135\",\"255.255.111.35\"]"},{"input":"\"0000\"","output":"[\"0.0.0.0\"]"},{"input":"\"101023\"","output":"[\"1.0.10.23\",\"1.0.102.3\",\"10.1.0.23\",\"10.10.2.3\",\"101.0.2.3\"]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking to try placing dots.","Try 1, 2, or 3 digits for each segment.","Validate: 0 <= value <= 255 and no leading zeros (except ''0'').","Need exactly 4 segments."]'::jsonb,
  45.9,
  '["Amazon","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'flood-fill',
  'Flood Fill',
  'flood-fill',
  'easy',
  'An image is represented by an `m x n` integer grid `image` where `image[i][j]` represents the pixel value of the image.

You are also given three integers `sr`, `sc`, and `color`. You should perform a flood fill on the image starting from the pixel `image[sr][sc]`.

To perform a flood fill, consider the starting pixel, plus any pixels connected 4-directionally to the starting pixel of the same color as the starting pixel, plus any pixels connected 4-directionally to those pixels (also with the same color), and so on. Replace the color of all of the aforementioned pixels with `color`.

Return the modified image after performing the flood fill.',
  '[{"input":"image = [[1,1,1],[1,1,0],[1,0,1]], sr = 1, sc = 1, color = 2","output":"[[2,2,2],[2,2,0],[2,0,1]]","explanation":"From the center of the image with position (sr, sc) = (1, 1) (i.e., the red pixel), all pixels connected by a path of the same color as the starting pixel (i.e., the blue pixels) are colored with the new color.\nNote the bottom corner is not colored 2, because it is not 4-directionally connected to the starting pixel."},{"input":"image = [[0,0,0],[0,0,0]], sr = 0, sc = 0, color = 0","output":"[[0,0,0],[0,0,0]]","explanation":"The starting pixel is already colored 0, so no changes are made to the image."}]'::jsonb,
  '["m == image.length","n == image[i].length","1 <= m, n <= 50","0 <= image[i][j], color < 2^16","0 <= sr < m","0 <= sc < n"]'::jsonb,
  '["Array","Depth-First Search","Breadth-First Search","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function floodFill(image, sr, sc, color) {\n  // Your code here\n}","python":"def floodFill(image, sr, sc, color):\n    # Your code here\n    pass","java":"class Solution {\n    public int[][] floodFill(int[][] image, int sr, int sc, int color) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,1,1],[1,1,0],[1,0,1]], 1, 1, 2","output":"[[2,2,2],[2,2,0],[2,0,1]]"},{"input":"[[0,0,0],[0,0,0]], 0, 0, 0","output":"[[0,0,0],[0,0,0]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use DFS or BFS from starting position.","Check if new color equals old color to avoid infinite loop.","Visit all 4-directionally connected cells with same color.","Change color of all visited cells."]'::jsonb,
  62.8,
  '["Amazon","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-moves-spread-stones',
  'Minimum Moves to Spread Stones Over Grid',
  'minimum-moves-spread-stones',
  'medium',
  'You are given a 0-indexed 2D integer matrix `grid` of size `3 * 3`, representing the number of stones in each cell. The grid contains exactly `9` stones, and there can be multiple stones in a single cell.

In one move, you can move a single stone from its current cell to any other cell if the two cells share a side.

Return the minimum number of moves required to place one stone in each cell.',
  '[{"input":"grid = [[1,1,0],[1,1,1],[1,2,1]]","output":"3","explanation":"One possible sequence of moves to place one stone in each cell is:\n1- Move one stone from cell (2,1) to cell (2,2).\n2- Move one stone from cell (2,2) to cell (1,2).\n3- Move one stone from cell (1,2) to cell (0,2).\nIn total, it takes 3 moves to place one stone in each cell of the grid.\nIt can be shown that 3 is the minimum number of moves required to place one stone in each cell."},{"input":"grid = [[1,3,0],[1,0,0],[1,0,3]]","output":"4"}]'::jsonb,
  '["grid.length == grid[i].length == 3","0 <= grid[i][j] <= 9","Sum of grid equals 9"]'::jsonb,
  '["Array","Dynamic Programming","Breadth-First Search","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumMoves(grid) {\n  // Your code here\n}","python":"def minimumMoves(grid):\n    # Your code here\n    pass","java":"class Solution {\n    public int minimumMoves(int[][] grid) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,1,0],[1,1,1],[1,2,1]]","output":"3"},{"input":"[[1,3,0],[1,0,0],[1,0,3]]","output":"4"}]'::jsonb,
  '[]'::jsonb,
  '["Find cells with excess stones and cells needing stones.","Use backtracking to try all assignment combinations.","Calculate Manhattan distance for each assignment.","Find minimum total distance."]'::jsonb,
  54.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-tree-paths',
  'Binary Tree Paths',
  'binary-tree-paths',
  'easy',
  'Given the `root` of a binary tree, return all root-to-leaf paths in any order.

A leaf is a node with no children.',
  '[{"input":"root = [1,2,3,null,5]","output":"[\"1->2->5\",\"1->3\"]"},{"input":"root = [1]","output":"[\"1\"]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 100]","-100 <= Node.val <= 100"]'::jsonb,
  '["String","Backtracking","Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function binaryTreePaths(root) {\n  // Your code here\n}","python":"def binaryTreePaths(root):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> binaryTreePaths(TreeNode root) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,3,null,5]","output":"[\"1->2->5\",\"1->3\"]"},{"input":"[1]","output":"[\"1\"]"}]'::jsonb,
  '[]'::jsonb,
  '["Use DFS with path tracking.","When reaching a leaf, add path to result.","Build path string with ''->'' separator.","Backtrack by removing last node from path."]'::jsonb,
  61.4,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-watch',
  'Binary Watch',
  'binary-watch',
  'easy',
  'A binary watch has 4 LEDs on the top to represent the hours (0-11), and 6 LEDs on the bottom to represent the minutes (0-59). Each LED represents a zero or one, with the least significant bit on the right.

Given an integer `turnedOn` which represents the number of LEDs that are currently on (ignoring the PM), return all possible times the watch could represent. You may return the answer in any order.

The hour must not contain a leading zero.
The minute must consist of two digits and may contain a leading zero.',
  '[{"input":"turnedOn = 1","output":"[\"0:01\",\"0:02\",\"0:04\",\"0:08\",\"0:16\",\"0:32\",\"1:00\",\"2:00\",\"4:00\",\"8:00\"]"},{"input":"turnedOn = 9","output":"[]"}]'::jsonb,
  '["0 <= turnedOn <= 10"]'::jsonb,
  '["Backtracking","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function readBinaryWatch(turnedOn) {\n  // Your code here\n}","python":"def readBinaryWatch(turnedOn):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> readBinaryWatch(int turnedOn) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"1","output":"[\"0:01\",\"0:02\",\"0:04\",\"0:08\",\"0:16\",\"0:32\",\"1:00\",\"2:00\",\"4:00\",\"8:00\"]"},{"input":"9","output":"[]"}]'::jsonb,
  '[]'::jsonb,
  '["Iterate through all possible hours (0-11) and minutes (0-59).","Count set bits in hour and minute.","If total set bits equals turnedOn, add to result.","Format minute with leading zero if needed."]'::jsonb,
  54.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'optimal-account-balancing',
  'Optimal Account Balancing',
  'optimal-account-balancing',
  'hard',
  'You are given an array of transactions `transactions` where `transactions[i] = [fromi, toi, amounti]` indicates that the person with `ID = fromi` gave `amounti $` to the person with `ID = toi`.

Return the minimum number of transactions required to settle the debt.',
  '[{"input":"transactions = [[0,1,10],[2,0,5]]","output":"2","explanation":"Person #0 gave person #1 $10.\nPerson #2 gave person #0 $5.\nTwo transactions are needed. One way to settle the debt is person #1 pays person #0 and #2 $5 each."},{"input":"transactions = [[0,1,10],[1,0,1],[1,2,5],[2,0,5]]","output":"1","explanation":"Person #0 gave person #1 $10.\nPerson #1 gave person #0 $1.\nPerson #1 gave person #2 $5.\nPerson #2 gave person #0 $5.\nTherefore, person #1 only need to give person #0 $4, and all debt is settled."}]'::jsonb,
  '["1 <= transactions.length <= 8","transactions[i].length == 3","0 <= fromi, toi < 12","fromi != toi","1 <= amounti <= 100"]'::jsonb,
  '["Array","Dynamic Programming","Backtracking","Bit Manipulation","Bitmask"]'::jsonb,
  'DSA',
  '{"javascript":"function minTransfers(transactions) {\n  // Your code here\n}","python":"def minTransfers(transactions):\n    # Your code here\n    pass","java":"class Solution {\n    public int minTransfers(int[][] transactions) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[0,1,10],[2,0,5]]","output":"2"},{"input":"[[0,1,10],[1,0,1],[1,2,5],[2,0,5]]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Calculate net balance for each person.","Remove people with zero balance.","Use backtracking to try settling debts.","Try pairing creditors with debtors to minimize transactions."]'::jsonb,
  53.8,
  '["Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'split-string-max-unique',
  'Split a String Into the Max Number of Unique Substrings',
  'split-string-max-unique',
  'medium',
  'Given a string `s`, return the maximum number of unique substrings that the given string can be split into.

You can split string `s` into any list of non-empty substrings, where the concatenation of the substrings forms the original string. However, you must split the substrings such that all of them are unique.

A substring is a contiguous sequence of characters within a string.',
  '[{"input":"s = \"ababccc\"","output":"5","explanation":"One way to split maximally is [''a'', ''b'', ''ab'', ''c'', ''cc'']. Splitting like [''a'', ''b'', ''a'', ''b'', ''c'', ''cc''] is not valid as you have ''a'' and ''b'' multiple times."},{"input":"s = \"aba\"","output":"2","explanation":"One way to split maximally is [''a'', ''ba'']."},{"input":"s = \"aa\"","output":"1","explanation":"It is impossible to split the string any further."}]'::jsonb,
  '["1 <= s.length <= 16","s contains only lower case English letters"]'::jsonb,
  '["Hash Table","String","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function maxUniqueSplit(s) {\n  // Your code here\n}","python":"def maxUniqueSplit(s):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxUniqueSplit(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"ababccc\"","output":"5"},{"input":"\"aba\"","output":"2"},{"input":"\"aa\"","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with a set to track used substrings.","Try all possible splits from current position.","Track maximum count of unique substrings.","Backtrack by removing substring from set."]'::jsonb,
  54.9,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'all-paths-source-target',
  'All Paths From Source to Target',
  'all-paths-source-target',
  'medium',
  'Given a directed acyclic graph (DAG) of `n` nodes labeled from `0` to `n - 1`, find all possible paths from node `0` to node `n - 1` and return them in any order.

The graph is given as follows: `graph[i]` is a list of all nodes you can visit from node `i` (i.e., there is a directed edge from node `i` to node `graph[i][j]`).',
  '[{"input":"graph = [[1,2],[3],[3],[]]","output":"[[0,1,3],[0,2,3]]","explanation":"There are two paths: 0 -> 1 -> 3 and 0 -> 2 -> 3."},{"input":"graph = [[4,3,1],[3,2,4],[3],[4],[]]","output":"[[0,4],[0,3,4],[0,1,3,4],[0,1,2,3,4],[0,1,4]]"}]'::jsonb,
  '["n == graph.length","2 <= n <= 15","0 <= graph[i][j] < n","graph[i][j] != i (i.e., there will be no self-loops)","All the elements of graph[i] are unique","The input graph is guaranteed to be a DAG"]'::jsonb,
  '["Backtracking","Depth-First Search","Breadth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function allPathsSourceTarget(graph) {\n  // Your code here\n}","python":"def allPathsSourceTarget(graph):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> allPathsSourceTarget(int[][] graph) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,2],[3],[3],[]]","output":"[[0,1,3],[0,2,3]]"},{"input":"[[4,3,1],[3,2,4],[3],[4],[]]","output":"[[0,4],[0,3,4],[0,1,3,4],[0,1,2,3,4],[0,1,4]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use DFS with path tracking.","Start from node 0 with path [0].","When reaching node n-1, add path to result.","Explore all neighbors recursively."]'::jsonb,
  82.1,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-invalid-parentheses',
  'Remove Invalid Parentheses',
  'remove-invalid-parentheses',
  'hard',
  'Given a string `s` that contains parentheses and letters, remove the minimum number of invalid parentheses to make the input string valid.

Return a list of unique strings that are valid with the minimum number of removals. You may return the answer in any order.',
  '[{"input":"s = \"()())()\"","output":"[\"(())()\",\"()()()\"]"},{"input":"s = \"(a)())()\"","output":"[\"(a())()\",\"(a)()()\"]"},{"input":"s = \")(\"","output":"[\"\"]"}]'::jsonb,
  '["1 <= s.length <= 25","s consists of lowercase English letters and parentheses ''('' and '')''","There will be at most 20 parentheses in s"]'::jsonb,
  '["String","Backtracking","Breadth-First Search"]'::jsonb,
  'DSA',
  '{"javascript":"function removeInvalidParentheses(s) {\n  // Your code here\n}","python":"def removeInvalidParentheses(s):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> removeInvalidParentheses(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"()())()\"","output":"[\"(())()\",\"()()()\"]"},{"input":"\"(a)())()\"","output":"[\"(a())()\",\"(a)()()\"]"},{"input":"\")(\"","output":"[\"\"]"}]'::jsonb,
  '[]'::jsonb,
  '["Calculate minimum removals needed (left and right mismatches).","Use backtracking to try removing each parenthesis.","Use set to avoid duplicate results.","Validate string after each removal combination."]'::jsonb,
  48.2,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'n-queens',
  'N-Queens',
  'n-queens',
  'hard',
  'The n-queens puzzle is the problem of placing `n` queens on an `n x n` chessboard such that no two queens attack each other.

Given an integer `n`, return all distinct solutions to the n-queens puzzle. You may return the answer in any order.

Each solution contains a distinct board configuration of the n-queens'' placement, where `''Q''` and `''.''` both indicate a queen and an empty space, respectively.',
  '[{"input":"n = 4","output":"[[\".Q..\",\"...Q\",\"Q...\",\"..Q.\"],[\"..Q.\",\"Q...\",\"...Q\",\".Q..\"]]","explanation":"There exist two distinct solutions to the 4-queens puzzle as shown above"},{"input":"n = 1","output":"[[\"Q\"]]"}]'::jsonb,
  '["1 <= n <= 9"]'::jsonb,
  '["Array","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function solveNQueens(n) {\n  // Your code here\n}","python":"def solveNQueens(n):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<String>> solveNQueens(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"4","output":"[[\".Q..\",\"...Q\",\"Q...\",\"..Q.\"],[\"..Q.\",\"Q...\",\"...Q\",\".Q..\"]]"},{"input":"1","output":"[[\"Q\"]]"}]'::jsonb,
  '[]'::jsonb,
  '["Similar to N-Queens II but store board configurations.","Use sets to track columns, diagonals, anti-diagonals.","Build board representation when reaching last row.","Use backtracking row by row."]'::jsonb,
  67.8,
  '["Amazon","Google","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'unique-paths-iii',
  'Unique Paths III',
  'unique-paths-iii',
  'hard',
  'You are given an `m x n` integer array `grid` where `grid[i][j]` could be:
- `1` representing the starting square. There is exactly one starting square.
- `2` representing the ending square. There is exactly one ending square.
- `0` representing empty squares we can walk over.
- `-1` representing obstacles that we cannot walk over.

Return the number of 4-directional walks from the starting square to the ending square, that walk over every non-obstacle square exactly once.',
  '[{"input":"grid = [[1,0,0,0],[0,0,0,0],[0,0,2,-1]]","output":"2","explanation":"We have the following two paths: \n1. (0,0),(0,1),(0,2),(0,3),(1,3),(1,2),(1,1),(1,0),(2,0),(2,1),(2,2)\n2. (0,0),(1,0),(2,0),(2,1),(1,1),(0,1),(0,2),(0,3),(1,3),(1,2),(2,2)"},{"input":"grid = [[1,0,0,0],[0,0,0,0],[0,0,0,2]]","output":"4","explanation":"We have the following four paths: \n1. (0,0),(0,1),(0,2),(0,3),(1,3),(1,2),(1,1),(1,0),(2,0),(2,1),(2,2),(2,3)\n2. (0,0),(0,1),(1,1),(1,0),(2,0),(2,1),(2,2),(1,2),(0,2),(0,3),(1,3),(2,3)\n3. (0,0),(1,0),(2,0),(2,1),(2,2),(1,2),(1,1),(0,1),(0,2),(0,3),(1,3),(2,3)\n4. (0,0),(1,0),(2,0),(2,1),(1,1),(0,1),(0,2),(0,3),(1,3),(1,2),(2,2),(2,3)"}]'::jsonb,
  '["m == grid.length","n == grid[i].length","1 <= m, n <= 20","1 <= m * n <= 20","-1 <= grid[i][j] <= 2","There is exactly one starting cell and one ending cell"]'::jsonb,
  '["Array","Backtracking","Bit Manipulation","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function uniquePathsIII(grid) {\n  // Your code here\n}","python":"def uniquePathsIII(grid):\n    # Your code here\n    pass","java":"class Solution {\n    public int uniquePathsIII(int[][] grid) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[1,0,0,0],[0,0,0,0],[0,0,2,-1]]","output":"2"},{"input":"[[1,0,0,0],[0,0,0,0],[0,0,0,2]]","output":"4"}]'::jsonb,
  '[]'::jsonb,
  '["Count total empty squares (including start).","Use DFS backtracking from start position.","Track visited cells and count.","When reaching end with all squares visited, increment result."]'::jsonb,
  81.2,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'combinations',
  'Combinations',
  'combinations',
  'medium',
  'Given two integers `n` and `k`, return all possible combinations of `k` numbers chosen from the range `[1, n]`.

You may return the answer in any order.',
  '[{"input":"n = 4, k = 2","output":"[[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]","explanation":"There are 4 choose 2 = 6 total combinations.\nNote that combinations are unordered, i.e., [1,2] and [2,1] are considered to be the same combination."},{"input":"n = 1, k = 1","output":"[[1]]","explanation":"There is 1 choose 1 = 1 total combination."}]'::jsonb,
  '["1 <= n <= 20","1 <= k <= n"]'::jsonb,
  '["Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function combine(n, k) {\n  // Your code here\n}","python":"def combine(n, k):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> combine(int n, int k) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"4, 2","output":"[[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]"},{"input":"1, 1","output":"[[1]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with start position to avoid duplicates.","Try adding numbers from start to n.","When combination size reaches k, add to result.","Backtrack by removing last number."]'::jsonb,
  70.2,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sudoku-solver',
  'Sudoku Solver',
  'sudoku-solver',
  'hard',
  'Write a program to solve a Sudoku puzzle by filling the empty cells.

A sudoku solution must satisfy all of the following rules:
1. Each of the digits `1-9` must occur exactly once in each row.
2. Each of the digits `1-9` must occur exactly once in each column.
3. Each of the digits `1-9` must occur exactly once in each of the 9 `3x3` sub-boxes of the grid.

The `''.''` character indicates empty cells.',
  '[{"input":"board = [[\"5\",\"3\",\".\",\".\",\"7\",\".\",\".\",\".\",\".\"],[\"6\",\".\",\".\",\"1\",\"9\",\"5\",\".\",\".\",\".\"],[\".\",\"9\",\"8\",\".\",\".\",\".\",\".\",\"6\",\".\"],[\"8\",\".\",\".\",\".\",\"6\",\".\",\".\",\".\",\"3\"],[\"4\",\".\",\".\",\"8\",\".\",\"3\",\".\",\".\",\"1\"],[\"7\",\".\",\".\",\".\",\"2\",\".\",\".\",\".\",\"6\"],[\".\",\"6\",\".\",\".\",\".\",\".\",\"2\",\"8\",\".\"],[\".\",\".\",\".\",\"4\",\"1\",\"9\",\".\",\".\",\"5\"],[\".\",\".\",\".\",\".\",\"8\",\".\",\".\",\"7\",\"9\"]]","output":"[[\"5\",\"3\",\"4\",\"6\",\"7\",\"8\",\"9\",\"1\",\"2\"],[\"6\",\"7\",\"2\",\"1\",\"9\",\"5\",\"3\",\"4\",\"8\"],[\"1\",\"9\",\"8\",\"3\",\"4\",\"2\",\"5\",\"6\",\"7\"],[\"8\",\"5\",\"9\",\"7\",\"6\",\"1\",\"4\",\"2\",\"3\"],[\"4\",\"2\",\"6\",\"8\",\"5\",\"3\",\"7\",\"9\",\"1\"],[\"7\",\"1\",\"3\",\"9\",\"2\",\"4\",\"8\",\"5\",\"6\"],[\"9\",\"6\",\"1\",\"5\",\"3\",\"7\",\"2\",\"8\",\"4\"],[\"2\",\"8\",\"7\",\"4\",\"1\",\"9\",\"6\",\"3\",\"5\"],[\"3\",\"4\",\"5\",\"2\",\"8\",\"6\",\"1\",\"7\",\"9\"]]"}]'::jsonb,
  '["board.length == 9","board[i].length == 9","board[i][j] is a digit 1-9 or ''.''","It is guaranteed that the input board has only one solution"]'::jsonb,
  '["Array","Hash Table","Backtracking","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function solveSudoku(board) {\n  // Your code here\n}","python":"def solveSudoku(board):\n    # Your code here\n    pass","java":"class Solution {\n    public void solveSudoku(char[][] board) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"board (see example)","output":"solved board (see example)"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking to try digits 1-9 in each empty cell.","Check if digit is valid (not in row, column, or 3x3 box).","If valid, place digit and recurse.","If recursion fails, backtrack and try next digit."]'::jsonb,
  58.4,
  '["Amazon","Microsoft","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'matchsticks-to-square',
  'Matchsticks to Square',
  'matchsticks-to-square',
  'medium',
  'You are given an integer array `matchsticks` where `matchsticks[i]` is the length of the `ith` matchstick. You want to use all the matchsticks to make one square. You should not break any stick, but you can link them up, and each matchstick must be used exactly one time.

Return `true` if you can make this square and `false` otherwise.',
  '[{"input":"matchsticks = [1,1,2,2,2]","output":"true","explanation":"You can form a square with length 2, one side of the square came two sticks with length 1."},{"input":"matchsticks = [3,3,3,3,4]","output":"false","explanation":"You cannot find a way to form a square with all the matchsticks."}]'::jsonb,
  '["1 <= matchsticks.length <= 15","1 <= matchsticks[i] <= 10^8"]'::jsonb,
  '["Array","Dynamic Programming","Backtracking","Bit Manipulation","Bitmask"]'::jsonb,
  'DSA',
  '{"javascript":"function makesquare(matchsticks) {\n  // Your code here\n}","python":"def makesquare(matchsticks):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean makesquare(int[] matchsticks) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,1,2,2,2]","output":"true"},{"input":"[3,3,3,3,4]","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Calculate side length = sum / 4. If not divisible, return false.","Sort matchsticks in descending order for optimization.","Use backtracking to try assigning each stick to 4 sides.","Similar to partition k subsets with k=4."]'::jsonb,
  40.8,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'coin-change',
  'Coin Change',
  'coin-change',
  'medium',
  'You are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money.

Return the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return `-1`.

You may assume that you have an infinite number of each kind of coin.',
  '[{"input":"coins = [1,2,5], amount = 11","output":"3","explanation":"11 = 5 + 5 + 1"},{"input":"coins = [2], amount = 3","output":"-1"},{"input":"coins = [1], amount = 0","output":"0"}]'::jsonb,
  '["1 <= coins.length <= 12","1 <= coins[i] <= 2^31 - 1","0 <= amount <= 10^4"]'::jsonb,
  '["Array","Dynamic Programming","Breadth-First Search"]'::jsonb,
  'DSA',
  '{"javascript":"function coinChange(coins, amount) {\n  // Your code here\n}","python":"def coinChange(coins, amount):\n    # Your code here\n    pass","java":"class Solution {\n    public int coinChange(int[] coins, int amount) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,5], 11","output":"3"},{"input":"[2], 3","output":"-1"},{"input":"[1], 0","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["Use DP array where dp[i] = minimum coins needed for amount i.","Initialize dp[0] = 0, others to infinity.","For each amount, try each coin: dp[i] = min(dp[i], dp[i-coin] + 1).","Return dp[amount] if it''s not infinity, else -1."]'::jsonb,
  43.2,
  '["Amazon","Microsoft","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'n-th-tribonacci-number',
  'N-th Tribonacci Number',
  'n-th-tribonacci-number',
  'easy',
  'The Tribonacci sequence Tn is defined as follows:

T0 = 0, T1 = 1, T2 = 1, and Tn+3 = Tn + Tn+1 + Tn+2 for n >= 0.

Given `n`, return the value of Tn.',
  '[{"input":"n = 4","output":"4","explanation":"T_3 = 0 + 1 + 1 = 2\nT_4 = 1 + 1 + 2 = 4"},{"input":"n = 25","output":"1389537"}]'::jsonb,
  '["0 <= n <= 37","The answer is guaranteed to fit within a 32-bit integer, ie. answer <= 2^31 - 1"]'::jsonb,
  '["Math","Dynamic Programming","Memoization"]'::jsonb,
  'DSA',
  '{"javascript":"function tribonacci(n) {\n  // Your code here\n}","python":"def tribonacci(n):\n    # Your code here\n    pass","java":"class Solution {\n    public int tribonacci(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"4","output":"4"},{"input":"25","output":"1389537"}]'::jsonb,
  '[]'::jsonb,
  '["Use three variables to track last three values.","Similar to Fibonacci but sum of three previous numbers.","Space optimized: O(1) instead of O(n) array.","Handle base cases: n=0, n=1, n=2."]'::jsonb,
  63.4,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'counting-bits',
  'Counting Bits',
  'counting-bits',
  'easy',
  'Given an integer `n`, return an array `ans` of length `n + 1` such that for each `i` (0 <= i <= n), `ans[i]` is the number of `1`''s in the binary representation of `i`.',
  '[{"input":"n = 2","output":"[0,1,1]","explanation":"0 --> 0\n1 --> 1\n2 --> 10"},{"input":"n = 5","output":"[0,1,1,2,1,2]","explanation":"0 --> 0\n1 --> 1\n2 --> 10\n3 --> 11\n4 --> 100\n5 --> 101"}]'::jsonb,
  '["0 <= n <= 10^5"]'::jsonb,
  '["Dynamic Programming","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function countBits(n) {\n  // Your code here\n}","python":"def countBits(n):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] countBits(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"2","output":"[0,1,1]"},{"input":"5","output":"[0,1,1,2,1,2]"}]'::jsonb,
  '[]'::jsonb,
  '["DP relation: dp[i] = dp[i >> 1] + (i & 1).","Right shift removes last bit, & 1 checks if last bit is 1.","Or use: dp[i] = dp[i & (i-1)] + 1.","Build answer iteratively from 0 to n."]'::jsonb,
  77.8,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  '01-matrix',
  '01 Matrix',
  '01-matrix',
  'medium',
  'Given an `m x n` binary matrix `mat`, return the distance of the nearest `0` for each cell.

The distance between two adjacent cells is `1`.',
  '[{"input":"mat = [[0,0,0],[0,1,0],[0,0,0]]","output":"[[0,0,0],[0,1,0],[0,0,0]]"},{"input":"mat = [[0,0,0],[0,1,0],[1,1,1]]","output":"[[0,0,0],[0,1,0],[1,2,1]]"}]'::jsonb,
  '["m == mat.length","n == mat[i].length","1 <= m, n <= 10^4","1 <= m * n <= 10^4","mat[i][j] is either 0 or 1","There is at least one 0 in mat"]'::jsonb,
  '["Array","Dynamic Programming","Breadth-First Search","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function updateMatrix(mat) {\n  // Your code here\n}","python":"def updateMatrix(mat):\n    # Your code here\n    pass","java":"class Solution {\n    public int[][] updateMatrix(int[][] mat) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[0,0,0],[0,1,0],[0,0,0]]","output":"[[0,0,0],[0,1,0],[0,0,0]]"},{"input":"[[0,0,0],[0,1,0],[1,1,1]]","output":"[[0,0,0],[0,1,0],[1,2,1]]"}]'::jsonb,
  '[]'::jsonb,
  '["Use multi-source BFS starting from all 0 cells.","Add all 0 positions to queue initially.","For each position, update neighbors with distance + 1.","Or use DP with two passes (top-left to bottom-right, then reverse)."]'::jsonb,
  48.9,
  '["Amazon","Google","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'house-robber-ii',
  'House Robber II',
  'house-robber-ii',
  'medium',
  'You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed. All houses at this place are arranged in a circle. That means the first house is the neighbor of the last one. Meanwhile, adjacent houses have a security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night.

Given an integer array `nums` representing the amount of money of each house, return the maximum amount of money you can rob tonight without alerting the police.',
  '[{"input":"nums = [2,3,2]","output":"3","explanation":"You cannot rob house 1 (money = 2) and then rob house 3 (money = 2), because they are adjacent houses."},{"input":"nums = [1,2,3,1]","output":"4","explanation":"Rob house 1 (money = 1) and then rob house 3 (money = 3). Total amount you can rob = 1 + 3 = 4."},{"input":"nums = [1,2,3]","output":"3"}]'::jsonb,
  '["1 <= nums.length <= 100","0 <= nums[i] <= 1000"]'::jsonb,
  '["Array","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function rob(nums) {\n  // Your code here\n}","python":"def rob(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int rob(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,3,2]","output":"3"},{"input":"[1,2,3,1]","output":"4"},{"input":"[1,2,3]","output":"3"}]'::jsonb,
  '[]'::jsonb,
  '["Can''t rob both first and last house (circular).","Run House Robber I twice: once excluding first, once excluding last.","Return maximum of both results.","Handle edge case: single house."]'::jsonb,
  41.2,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-product-subarray',
  'Maximum Product Subarray',
  'maximum-product-subarray',
  'medium',
  'Given an integer array `nums`, find a subarray that has the largest product, and return the product.

The test cases are generated so that the answer will fit in a 32-bit integer.',
  '[{"input":"nums = [2,3,-2,4]","output":"6","explanation":"[2,3] has the largest product 6."},{"input":"nums = [-2,0,-1]","output":"0","explanation":"The result cannot be 2, because [-2,-1] is not a subarray."}]'::jsonb,
  '["1 <= nums.length <= 2 * 10^4","-10 <= nums[i] <= 10","The product of any subarray of nums is guaranteed to fit in a 32-bit integer"]'::jsonb,
  '["Array","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function maxProduct(nums) {\n  // Your code here\n}","python":"def maxProduct(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int maxProduct(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,3,-2,4]","output":"6"},{"input":"[-2,0,-1]","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["Track both maximum and minimum product ending at current position.","Negative number can flip max and min.","Update: maxProd = max(num, maxProd*num, minProd*num).","Similarly for minProd, then update global max."]'::jsonb,
  35.1,
  '["Amazon","Microsoft","Apple","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'combination-sum',
  'Combination Sum',
  'combination-sum',
  'medium',
  'Given an array of distinct integers `candidates` and a target integer `target`, return a list of all unique combinations of `candidates` where the chosen numbers sum to `target`. You may return the combinations in any order.

The same number may be chosen from `candidates` an unlimited number of times. Two combinations are unique if the frequency of at least one of the chosen numbers is different.

The test cases are generated such that the number of unique combinations that sum up to `target` is less than `150` combinations for the given input.',
  '[{"input":"candidates = [2,3,6,7], target = 7","output":"[[2,2,3],[7]]","explanation":"2 and 3 are candidates, and 2 + 2 + 3 = 7. Note that 2 can be used multiple times.\n7 is a candidate, and 7 = 7.\nThese are the only two combinations."},{"input":"candidates = [2,3,5], target = 8","output":"[[2,2,2,2],[2,3,3],[3,5]]"},{"input":"candidates = [2], target = 1","output":"[]"}]'::jsonb,
  '["1 <= candidates.length <= 30","2 <= candidates[i] <= 40","All elements of candidates are distinct","1 <= target <= 40"]'::jsonb,
  '["Array","Backtracking"]'::jsonb,
  'DSA',
  '{"javascript":"function combinationSum(candidates, target) {\n  // Your code here\n}","python":"def combinationSum(candidates, target):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> combinationSum(int[] candidates, int target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[2,3,6,7], 7","output":"[[2,2,3],[7]]"},{"input":"[2,3,5], 8","output":"[[2,2,2,2],[2,3,3],[3,5]]"},{"input":"[2], 1","output":"[]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with remaining target.","Allow same element to be used multiple times (don''t increment start index).","When target becomes 0, add current combination.","Prune when target becomes negative."]'::jsonb,
  70.8,
  '["Amazon","Facebook","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'word-break',
  'Word Break',
  'word-break',
  'medium',
  'Given a string `s` and a dictionary of strings `wordDict`, return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words.

Note that the same word in the dictionary may be reused multiple times in the segmentation.',
  '[{"input":"s = \"leetcode\", wordDict = [\"leet\",\"code\"]","output":"true","explanation":"Return true because \"leetcode\" can be segmented as \"leet code\"."},{"input":"s = \"applepenapple\", wordDict = [\"apple\",\"pen\"]","output":"true","explanation":"Return true because \"applepenapple\" can be segmented as \"apple pen apple\". Note that you are allowed to reuse a dictionary word."},{"input":"s = \"catsandog\", wordDict = [\"cats\",\"dog\",\"sand\",\"and\",\"cat\"]","output":"false"}]'::jsonb,
  '["1 <= s.length <= 300","1 <= wordDict.length <= 1000","1 <= wordDict[i].length <= 20","s and wordDict[i] consist of only lowercase English letters","All the strings of wordDict are unique"]'::jsonb,
  '["Array","Hash Table","String","Dynamic Programming","Trie","Memoization"]'::jsonb,
  'DSA',
  '{"javascript":"function wordBreak(s, wordDict) {\n  // Your code here\n}","python":"def wordBreak(s, wordDict):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean wordBreak(String s, List<String> wordDict) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"leetcode\", [\"leet\",\"code\"]","output":"true"},{"input":"\"applepenapple\", [\"apple\",\"pen\"]","output":"true"},{"input":"\"catsandog\", [\"cats\",\"dog\",\"sand\",\"and\",\"cat\"]","output":"false"}]'::jsonb,
  '[]'::jsonb,
  '["Use DP array where dp[i] = true if s[0..i-1] can be segmented.","For each position i, check all words ending at i.","If word found and dp[i-word.length] is true, set dp[i] = true.","Convert wordDict to Set for O(1) lookup."]'::jsonb,
  46.9,
  '["Amazon","Google","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'palindromic-substrings',
  'Palindromic Substrings',
  'palindromic-substrings',
  'medium',
  'Given a string `s`, return the number of palindromic substrings in it.

A string is a palindrome when it reads the same backward as forward.

A substring is a contiguous sequence of characters within the string.',
  '[{"input":"s = \"abc\"","output":"3","explanation":"Three palindromic strings: \"a\", \"b\", \"c\"."},{"input":"s = \"aaa\"","output":"6","explanation":"Six palindromic strings: \"a\", \"a\", \"a\", \"aa\", \"aa\", \"aaa\"."}]'::jsonb,
  '["1 <= s.length <= 1000","s consists of lowercase English letters"]'::jsonb,
  '["String","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function countSubstrings(s) {\n  // Your code here\n}","python":"def countSubstrings(s):\n    # Your code here\n    pass","java":"class Solution {\n    public int countSubstrings(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"abc\"","output":"3"},{"input":"\"aaa\"","output":"6"}]'::jsonb,
  '[]'::jsonb,
  '["Expand around center approach: try each position as center.","For each center, expand while characters match.","Handle both odd-length (single center) and even-length (two centers).","Or use DP: dp[i][j] = true if s[i..j] is palindrome."]'::jsonb,
  68.9,
  '["Amazon","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-common-subsequence',
  'Longest Common Subsequence',
  'longest-common-subsequence',
  'medium',
  'Given two strings `text1` and `text2`, return the length of their longest common subsequence. If there is no common subsequence, return `0`.

A subsequence of a string is a new string generated from the original string with some characters (can be none) deleted without changing the relative order of the remaining characters.

A common subsequence of two strings is a subsequence that is common to both strings.',
  '[{"input":"text1 = \"abcde\", text2 = \"ace\"","output":"3","explanation":"The longest common subsequence is \"ace\" and its length is 3."},{"input":"text1 = \"abc\", text2 = \"abc\"","output":"3","explanation":"The longest common subsequence is \"abc\" and its length is 3."},{"input":"text1 = \"abc\", text2 = \"def\"","output":"0","explanation":"There is no such common subsequence, so the result is 0."}]'::jsonb,
  '["1 <= text1.length, text2.length <= 1000","text1 and text2 consist of only lowercase English characters"]'::jsonb,
  '["String","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function longestCommonSubsequence(text1, text2) {\n  // Your code here\n}","python":"def longestCommonSubsequence(text1, text2):\n    # Your code here\n    pass","java":"class Solution {\n    public int longestCommonSubsequence(String text1, String text2) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"abcde\", \"ace\"","output":"3"},{"input":"\"abc\", \"abc\"","output":"3"},{"input":"\"abc\", \"def\"","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["Use 2D DP: dp[i][j] = LCS length of text1[0..i-1] and text2[0..j-1].","If text1[i-1] == text2[j-1]: dp[i][j] = dp[i-1][j-1] + 1.","Else: dp[i][j] = max(dp[i-1][j], dp[i][j-1]).","Can optimize to 1D array."]'::jsonb,
  58.4,
  '["Amazon","Google","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'word-break-ii',
  'Word Break II',
  'word-break-ii',
  'hard',
  'Given a string `s` and a dictionary of strings `wordDict`, add spaces in `s` to construct a sentence where each word is a valid dictionary word. Return all such possible sentences in any order.

Note that the same word in the dictionary may be reused multiple times in the segmentation.',
  '[{"input":"s = \"catsanddog\", wordDict = [\"cat\",\"cats\",\"and\",\"sand\",\"dog\"]","output":"[\"cats and dog\",\"cat sand dog\"]"},{"input":"s = \"pineapplepenapple\", wordDict = [\"apple\",\"pen\",\"applepen\",\"pine\",\"pineapple\"]","output":"[\"pine apple pen apple\",\"pineapple pen apple\",\"pine applepen apple\"]","explanation":"Note that you are allowed to reuse a dictionary word."},{"input":"s = \"catsandog\", wordDict = [\"cats\",\"dog\",\"sand\",\"and\",\"cat\"]","output":"[]"}]'::jsonb,
  '["1 <= s.length <= 20","1 <= wordDict.length <= 1000","1 <= wordDict[i].length <= 10","s and wordDict[i] consist of only lowercase English letters","All the strings of wordDict are unique","Input is generated in a way that the length of the answer doesn''t exceed 10^5"]'::jsonb,
  '["Array","Hash Table","String","Dynamic Programming","Backtracking","Trie","Memoization"]'::jsonb,
  'DSA',
  '{"javascript":"function wordBreak(s, wordDict) {\n  // Your code here\n}","python":"def wordBreak(s, wordDict):\n    # Your code here\n    pass","java":"class Solution {\n    public List<String> wordBreak(String s, List<String> wordDict) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"catsanddog\", [\"cat\",\"cats\",\"and\",\"sand\",\"dog\"]","output":"[\"cats and dog\",\"cat sand dog\"]"},{"input":"\"pineapplepenapple\", [\"apple\",\"pen\",\"applepen\",\"pine\",\"pineapple\"]","output":"[\"pine apple pen apple\",\"pineapple pen apple\",\"pine applepen apple\"]"},{"input":"\"catsandog\", [\"cats\",\"dog\",\"sand\",\"and\",\"cat\"]","output":"[]"}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with memoization.","For each position, try all words that match.","Recursively solve remaining substring.","Cache results for each substring to avoid recomputation."]'::jsonb,
  48.2,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'decode-ways',
  'Decode Ways',
  'decode-ways',
  'medium',
  'A message containing letters from `A-Z` can be encoded into numbers using the following mapping:

''A'' -> "1"
''B'' -> "2"
...
''Z'' -> "26"

To decode an encoded message, all the digits must be grouped then mapped back into letters using the reverse of the mapping above (there may be multiple ways). For example, `"11106"` can be mapped into:

- `"AAJF"` with the grouping `(1 1 10 6)`
- `"KJF"` with the grouping `(11 10 6)`

Note that the grouping `(1 11 06)` is invalid because `"06"` cannot be mapped into `''F''` since `"6"` is different from `"06"`.

Given a string `s` containing only digits, return the number of ways to decode it.

The test cases are generated so that the answer fits in a 32-bit integer.',
  '[{"input":"s = \"12\"","output":"2","explanation":"\"12\" could be decoded as \"AB\" (1 2) or \"L\" (12)."},{"input":"s = \"226\"","output":"3","explanation":"\"226\" could be decoded as \"BZ\" (2 26), \"VF\" (22 6), or \"BBF\" (2 2 6)."},{"input":"s = \"06\"","output":"0","explanation":"\"06\" cannot be mapped to \"F\" because of the leading zero (\"6\" is different from \"06\")."}]'::jsonb,
  '["1 <= s.length <= 100","s contains only digits and may contain leading zero(s)"]'::jsonb,
  '["String","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function numDecodings(s) {\n  // Your code here\n}","python":"def numDecodings(s):\n    # Your code here\n    pass","java":"class Solution {\n    public int numDecodings(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"12\"","output":"2"},{"input":"\"226\"","output":"3"},{"input":"\"06\"","output":"0"}]'::jsonb,
  '[]'::jsonb,
  '["DP: dp[i] = ways to decode s[0..i-1].","Single digit: if s[i-1] != ''0'', add dp[i-1].","Two digits: if 10 <= int(s[i-2:i]) <= 26, add dp[i-2].","Handle leading zeros carefully."]'::jsonb,
  35.2,
  '["Amazon","Microsoft","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-unique-good-subsequences',
  'Number of Unique Good Subsequences',
  'number-of-unique-good-subsequences',
  'hard',
  'You are given a binary string `binary`. A subsequence of `binary` is considered good if it is not empty and has no leading zeros (with the exception of `"0"`).

Find the number of unique good subsequences of `binary`.

Return the answer modulo `10^9 + 7`.

A subsequence is a sequence that can be derived from another sequence by deleting some or no elements without changing the order of the remaining elements.',
  '[{"input":"binary = \"001\"","output":"2","explanation":"The good subsequences are [\"0\", \"01\", \"1\"]. Note that \"00\" is not good because it has leading zeros."},{"input":"binary = \"11\"","output":"2","explanation":"The good subsequences are [\"1\", \"11\"]."},{"input":"binary = \"101\"","output":"5","explanation":"The good subsequences are [\"1\", \"01\", \"11\", \"101\", \"1\"]. Note that some subsequences appear multiple times but only count once."}]'::jsonb,
  '["1 <= binary.length <= 10^5","binary consists of only ''0''s and ''1''s"]'::jsonb,
  '["String","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function numberOfUniqueGoodSubsequences(binary) {\n  // Your code here\n}","python":"def numberOfUniqueGoodSubsequences(binary):\n    # Your code here\n    pass","java":"class Solution {\n    public int numberOfUniqueGoodSubsequences(String binary) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"\"001\"","output":"2"},{"input":"\"11\"","output":"2"},{"input":"\"101\"","output":"5"}]'::jsonb,
  '[]'::jsonb,
  '["Track count of subsequences ending with ''0'' and ''1'' separately.","When seeing ''1'': new subsequences = all previous + ''1'' alone.","When seeing ''0'': new subsequences = all previous + ''0'' appended.","Handle standalone ''0'' separately (if exists in string)."]'::jsonb,
  52.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-tree-cameras',
  'Binary Tree Cameras',
  'binary-tree-cameras',
  'hard',
  'You are given the `root` of a binary tree. We install cameras on the tree nodes where each camera at a node can monitor its parent, itself, and its immediate children.

Return the minimum number of cameras needed to monitor all nodes of the tree.',
  '[{"input":"root = [0,0,null,0,0]","output":"1","explanation":"One camera is enough to monitor all nodes if placed as shown."},{"input":"root = [0,0,null,0,null,0,null,null,0]","output":"2","explanation":"At least two cameras are needed to monitor all nodes of the tree."}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 1000]","Node.val == 0"]'::jsonb,
  '["Dynamic Programming","Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function minCameraCover(root) {\n  // Your code here\n}","python":"def minCameraCover(root):\n    # Your code here\n    pass","java":"class Solution {\n    public int minCameraCover(TreeNode root) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[0,0,null,0,0]","output":"1"},{"input":"[0,0,null,0,null,0,null,null,0]","output":"2"}]'::jsonb,
  '[]'::jsonb,
  '["Use greedy approach: place cameras as low as possible.","Post-order DFS with three states: 0=needs camera, 1=has camera, 2=covered.","If child needs camera, place at current node.","If current has camera, parent is covered."]'::jsonb,
  48.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-ways-to-form-target-string',
  'Number of Ways to Form a Target String Given a Dictionary',
  'number-of-ways-to-form-target-string',
  'hard',
  'You are given a list of strings of the same length `words` and a string `target`.

Your task is to form `target` using the given `words` under the following rules:

- `target` should be formed from left to right.
- To form the `ith` character (0-indexed) of `target`, you can choose the `kth` character of the `jth` string in `words` if `target[i] = words[j][k]`.
- Once you use the `kth` character of the `jth` string of `words`, you can no longer use the `xth` character of any string in `words` where `x <= k`. In other words, all characters to the left of or at index `k` become unusuable for every string.
- Repeat the process until you form the string `target`.

Notice that you can use multiple characters from the same string in `words` provided the conditions above are met.

Return the number of ways to form `target` from `words`. Since the answer may be too large, return it modulo `10^9 + 7`.',
  '[{"input":"words = [\"acca\",\"bbbb\",\"caca\"], target = \"aba\"","output":"6","explanation":"There are 6 ways to form target.\n\"aba\" -> index 0 (\"acca\"), index 1 (\"bbbb\"), index 3 (\"caca\")\n\"aba\" -> index 0 (\"acca\"), index 2 (\"bbbb\"), index 3 (\"caca\")\n\"aba\" -> index 0 (\"acca\"), index 1 (\"bbbb\"), index 3 (\"acca\")\n\"aba\" -> index 0 (\"acca\"), index 2 (\"bbbb\"), index 3 (\"acca\")\n\"aba\" -> index 1 (\"caca\"), index 2 (\"bbbb\"), index 3 (\"acca\")\n\"aba\" -> index 1 (\"caca\"), index 2 (\"bbbb\"), index 3 (\"caca\")"},{"input":"words = [\"abba\",\"baab\"], target = \"bab\"","output":"4","explanation":"There are 4 ways to form target.\n\"bab\" -> index 0 (\"baab\"), index 1 (\"baab\"), index 2 (\"abba\")\n\"bab\" -> index 0 (\"baab\"), index 1 (\"baab\"), index 3 (\"baab\")\n\"bab\" -> index 0 (\"baab\"), index 2 (\"baab\"), index 3 (\"baab\")\n\"bab\" -> index 1 (\"abba\"), index 2 (\"baab\"), index 3 (\"baab\")"}]'::jsonb,
  '["1 <= words.length <= 1000","1 <= words[i].length <= 1000","All strings in words have the same length","1 <= target.length <= 1000","words[i] and target contain only lowercase English letters"]'::jsonb,
  '["Array","String","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function numWays(words, target) {\n  // Your code here\n}","python":"def numWays(words, target):\n    # Your code here\n    pass","java":"class Solution {\n    public int numWays(String[] words, String target) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[\"acca\",\"bbbb\",\"caca\"], \"aba\"","output":"6"},{"input":"[\"abba\",\"baab\"], \"bab\"","output":"4"}]'::jsonb,
  '[]'::jsonb,
  '["Precompute frequency of each character at each position in words.","DP: dp[i][j] = ways to form target[0..i-1] using first j columns.","dp[i][j] = dp[i][j-1] (skip column) + dp[i-1][j-1] * freq[target[i-1]][j-1].","Use modulo arithmetic throughout."]'::jsonb,
  49.3,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'pascals-triangle',
  'Pascal''s Triangle',
  'pascals-triangle',
  'easy',
  'Given an integer `numRows`, return the first numRows of Pascal''s triangle.

In Pascal''s triangle, each number is the sum of the two numbers directly above it as shown:',
  '[{"input":"numRows = 5","output":"[[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]"},{"input":"numRows = 1","output":"[[1]]"}]'::jsonb,
  '["1 <= numRows <= 30"]'::jsonb,
  '["Array","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function generate(numRows) {\n  // Your code here\n}","python":"def generate(numRows):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> generate(int numRows) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"5","output":"[[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]"},{"input":"1","output":"[[1]]"}]'::jsonb,
  '[]'::jsonb,
  '["Each row starts and ends with 1.","Middle elements: row[i][j] = row[i-1][j-1] + row[i-1][j].","Build row by row using previous row.","First row is [1]."]'::jsonb,
  72.4,
  '["Amazon","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'triangle',
  'Triangle',
  'triangle',
  'medium',
  'Given a `triangle` array, return the minimum path sum from top to bottom.

For each step, you may move to an adjacent number of the row below. More formally, if you are on index `i` on the current row, you may move to either index `i` or index `i + 1` on the next row.',
  '[{"input":"triangle = [[2],[3,4],[6,5,7],[4,1,8,3]]","output":"11","explanation":"The triangle looks like:\n   2\n  3 4\n 6 5 7\n4 1 8 3\nThe minimum path sum from top to bottom is 2 + 3 + 5 + 1 = 11 (underlined above)."},{"input":"triangle = [[-10]]","output":"-10"}]'::jsonb,
  '["1 <= triangle.length <= 200","triangle[0].length == 1","triangle[i].length == triangle[i - 1].length + 1","-10^4 <= triangle[i][j] <= 10^4"]'::jsonb,
  '["Array","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumTotal(triangle) {\n  // Your code here\n}","python":"def minimumTotal(triangle):\n    # Your code here\n    pass","java":"class Solution {\n    public int minimumTotal(List<List<Integer>> triangle) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[[2],[3,4],[6,5,7],[4,1,8,3]]","output":"11"},{"input":"[[-10]]","output":"-10"}]'::jsonb,
  '[]'::jsonb,
  '["Bottom-up DP: start from second last row.","For each cell, add minimum of two adjacent cells below.","dp[i][j] = triangle[i][j] + min(dp[i+1][j], dp[i+1][j+1]).","Can optimize space by modifying triangle in-place."]'::jsonb,
  54.8,
  '["Amazon","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'climbing-stairs',
  'Climbing Stairs',
  'climbing-stairs',
  'easy',
  'You are climbing a staircase. It takes `n` steps to reach the top.

Each time you can either climb `1` or `2` steps. In how many distinct ways can you climb to the top?',
  '[{"input":"n = 2","output":"2","explanation":"There are two ways to climb to the top.\n1. 1 step + 1 step\n2. 2 steps"},{"input":"n = 3","output":"3","explanation":"There are three ways to climb to the top.\n1. 1 step + 1 step + 1 step\n2. 1 step + 2 steps\n3. 2 steps + 1 step"}]'::jsonb,
  '["1 <= n <= 45"]'::jsonb,
  '["Math","Dynamic Programming","Memoization"]'::jsonb,
  'DSA',
  '{"javascript":"function climbStairs(n) {\n  // Your code here\n}","python":"def climbStairs(n):\n    # Your code here\n    pass","java":"class Solution {\n    public int climbStairs(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"2","output":"2"},{"input":"3","output":"3"}]'::jsonb,
  '[]'::jsonb,
  '["This is Fibonacci sequence: dp[i] = dp[i-1] + dp[i-2].","Base cases: dp[1] = 1, dp[2] = 2.","Can reach step i from step i-1 (1 step) or step i-2 (2 steps).","Optimize to O(1) space using two variables."]'::jsonb,
  52.3,
  '["Amazon","Google","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'missing-number',
  'Missing Number',
  'missing-number',
  'easy',
  'Given an array `nums` containing `n` distinct numbers in the range `[0, n]`, return the only number in the range that is missing from the array.',
  '[{"input":"nums = [3,0,1]","output":"2","explanation":"n = 3 since there are 3 numbers, so all numbers are in the range [0,3]. 2 is the missing number in the range since it does not appear in nums."},{"input":"nums = [0,1]","output":"2","explanation":"n = 2 since there are 2 numbers, so all numbers are in the range [0,2]. 2 is the missing number in the range since it does not appear in nums."},{"input":"nums = [9,6,4,2,3,5,7,0,1]","output":"8","explanation":"n = 9 since there are 9 numbers, so all numbers are in the range [0,9]. 8 is the missing number in the range since it does not appear in nums."}]'::jsonb,
  '["n == nums.length","1 <= n <= 10^4","0 <= nums[i] <= n","All the numbers of nums are unique"]'::jsonb,
  '["Array","Hash Table","Math","Binary Search","Bit Manipulation","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function missingNumber(nums) {\n  // Your code here\n}","python":"def missingNumber(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int missingNumber(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[3,0,1]","output":"2"},{"input":"[0,1]","output":"2"},{"input":"[9,6,4,2,3,5,7,0,1]","output":"8"}]'::jsonb,
  '[]'::jsonb,
  '["Use sum formula: sum(0 to n) = n*(n+1)/2.","Subtract actual sum from expected sum.","Or use XOR: XOR all indices and values, result is missing number.","Cyclic sort approach: place each number at its index position."]'::jsonb,
  61.8,
  '["Amazon","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'first-missing-positive',
  'First Missing Positive',
  'first-missing-positive',
  'hard',
  'Given an unsorted integer array `nums`, return the smallest missing positive integer.

You must implement an algorithm that runs in `O(n)` time and uses `O(1)` auxiliary space.',
  '[{"input":"nums = [1,2,0]","output":"3","explanation":"The numbers in the range [1,2] are all in the array."},{"input":"nums = [3,4,-1,1]","output":"2","explanation":"1 is in the array but 2 is missing."},{"input":"nums = [7,8,9,11,12]","output":"1","explanation":"The smallest positive integer 1 is missing."}]'::jsonb,
  '["1 <= nums.length <= 10^5","-2^31 <= nums[i] <= 2^31 - 1"]'::jsonb,
  '["Array","Hash Table"]'::jsonb,
  'DSA',
  '{"javascript":"function firstMissingPositive(nums) {\n  // Your code here\n}","python":"def firstMissingPositive(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int firstMissingPositive(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,0]","output":"3"},{"input":"[3,4,-1,1]","output":"2"},{"input":"[7,8,9,11,12]","output":"1"}]'::jsonb,
  '[]'::jsonb,
  '["Use array itself as hash table: place each number at index = number - 1.","Ignore numbers <= 0 or > n.","After placement, first index without correct value gives answer.","Handle duplicates and out-of-range values carefully."]'::jsonb,
  37.8,
  '["Amazon","Microsoft","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'set-mismatch',
  'Set Mismatch',
  'set-mismatch',
  'easy',
  'You have a set of integers `s`, which originally contains all the numbers from `1` to `n`. Unfortunately, due to some error, one of the numbers in `s` got duplicated to another number in the set, which results in repetition of one number and loss of another number.

You are given an integer array `nums` representing the data status of this set after the error.

Find the number that occurs twice and the number that is missing and return them in the form of an array.',
  '[{"input":"nums = [1,2,2,4]","output":"[2,3]"},{"input":"nums = [1,1]","output":"[1,2]"}]'::jsonb,
  '["2 <= nums.length <= 10^4","1 <= nums[i] <= 10^4"]'::jsonb,
  '["Array","Hash Table","Bit Manipulation","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function findErrorNums(nums) {\n  // Your code here\n}","python":"def findErrorNums(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] findErrorNums(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[1,2,2,4]","output":"[2,3]"},{"input":"[1,1]","output":"[1,2]"}]'::jsonb,
  '[]'::jsonb,
  '["Use hash set to find duplicate.","Use sum formula to find missing: expected - (actual - duplicate).","Or mark visited by negating nums[abs(nums[i])-1].","Cyclic sort: place each number at correct position."]'::jsonb,
  43.2,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sort-array-by-parity-ii',
  'Sort Array By Parity II',
  'sort-array-by-parity-ii',
  'easy',
  'Given an array of integers `nums`, half of the integers in `nums` are odd, and the other half are even.

Sort the array so that whenever `nums[i]` is odd, `i` is odd, and whenever `nums[i]` is even, `i` is even.

Return any answer array that satisfies this condition.',
  '[{"input":"nums = [4,2,5,7]","output":"[4,5,2,7]","explanation":"[4,7,2,5], [2,5,4,7], [2,7,4,5] would also have been accepted."},{"input":"nums = [2,3]","output":"[2,3]"}]'::jsonb,
  '["2 <= nums.length <= 2 * 10^4","nums.length is even","Half of the integers in nums are even","0 <= nums[i] <= 1000"]'::jsonb,
  '["Array","Two Pointers","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function sortArrayByParityII(nums) {\n  // Your code here\n}","python":"def sortArrayByParityII(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public int[] sortArrayByParityII(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[4,2,5,7]","output":"[4,5,2,7]"},{"input":"[2,3]","output":"[2,3]"}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers: one for even indices (0,2,4...), one for odd (1,3,5...).","When finding mismatched pairs, swap them.","Or create result array and fill even/odd positions separately.","In-place: find even number at odd index and odd at even index, swap."]'::jsonb,
  71.2,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-all-numbers-disappeared',
  'Find All Numbers Disappeared in an Array',
  'find-all-numbers-disappeared',
  'hard',
  'Given an array `nums` of `n` integers where `nums[i]` is in the range `[1, n]`, return an array of all the integers in the range `[1, n]` that do not appear in `nums`.',
  '[{"input":"nums = [4,3,2,7,8,2,3,1]","output":"[5,6]"},{"input":"nums = [1,1]","output":"[2]"}]'::jsonb,
  '["n == nums.length","1 <= n <= 10^5","1 <= nums[i] <= n"]'::jsonb,
  '["Array","Hash Table"]'::jsonb,
  'DSA',
  '{"javascript":"function findDisappearedNumbers(nums) {\n  // Your code here\n}","python":"def findDisappearedNumbers(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public List<Integer> findDisappearedNumbers(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"input":"[4,3,2,7,8,2,3,1]","output":"[5,6]"},{"input":"[1,1]","output":"[2]"}]'::jsonb,
  '[]'::jsonb,
  '["Mark presence by negating value at index nums[i]-1.","After marking, positive indices indicate missing numbers.","O(n) time, O(1) space solution.","Cyclic sort approach: place each number at correct position."]'::jsonb,
  60.4,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-url-shortener',
  'Design URL Shortener (like bit.ly)',
  'design-url-shortener',
  'medium',
  'Design a URL shortening service like bit.ly or TinyURL.

**Requirements:**
1. Given a long URL, return a shortened URL
2. Given a shortened URL, redirect to the original long URL
3. URLs should be as short as possible
4. System should handle high traffic (millions of URLs per day)
5. URLs should not be predictable for security

**Key Considerations:**
- How to generate unique short codes
- Database design for storing mappings
- Handling scalability and high availability
- Expiration of URLs
- Analytics (click tracking)
- Custom short URLs',
  '[{"input":"longURL = \"https://www.example.com/very/long/url/path\"","output":"\"https://short.ly/aB3dE\"","explanation":"System generates a short unique code ''aB3dE'' and stores the mapping"}]'::jsonb,
  '["Handle 100M+ URL shortenings per month","Read:Write ratio approximately 100:1","URLs should be available for at least 5 years","Short URL length should be 6-7 characters"]'::jsonb,
  '["System Design","Scalability","Databases","Hashing"]'::jsonb,
  'System Design',
  '{"javascript":"// Design components:\n// 1. API endpoints\n// 2. Database schema\n// 3. Short code generation algorithm\n// 4. Scaling strategy","python":"# Design components:\n# 1. API endpoints\n# 2. Database schema\n# 3. Short code generation algorithm\n# 4. Scaling strategy","java":"// Design components:\n// 1. API endpoints\n// 2. Database schema\n// 3. Short code generation algorithm\n// 4. Scaling strategy"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use Base62 encoding (a-z, A-Z, 0-9) for short codes - gives 62^7 = 3.5 trillion possibilities","Consider using a hash function (MD5/SHA) and take first N characters","For uniqueness, check database or use distributed ID generator (Snowflake)","Use Redis for caching frequently accessed URLs","Partition database by hash of short code for scalability"]'::jsonb,
  0,
  '["Google","Facebook","Amazon","Microsoft"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-instagram',
  'Design Instagram',
  'design-instagram',
  'hard',
  'Design a photo-sharing social media platform like Instagram.

**Core Features:**
1. Users can upload photos/videos
2. Users can follow other users
3. News feed showing posts from followed users
4. Like and comment on posts
5. Direct messaging between users
6. Stories feature (24-hour expiration)

**Scale Requirements:**
- 500M+ daily active users
- 100M photos uploaded per day
- Low latency for feed generation
- High availability

**Technical Challenges:**
- Image storage and CDN delivery
- Feed generation algorithm
- Handling celebrity accounts (millions of followers)
- Real-time notifications',
  '[]'::jsonb,
  '["Feed should load in < 2 seconds","Support images up to 15MB","Videos up to 60 seconds","Handle 10,000 requests per second per region"]'::jsonb,
  '["System Design","Scalability","CDN","Feed Generation","NoSQL"]'::jsonb,
  'System Design',
  '{"javascript":"// Design components:\n// 1. User service\n// 2. Photo service\n// 3. Feed service\n// 4. Notification service\n// 5. Database architecture\n// 6. Caching strategy","python":"# Design components:\n# 1. User service\n# 2. Photo service\n# 3. Feed service\n# 4. Notification service\n# 5. Database architecture\n# 6. Caching strategy","java":"// Design components:\n// 1. User service\n// 2. Photo service\n// 3. Feed service\n// 4. Notification service\n// 5. Database architecture\n// 6. Caching strategy"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use object storage (S3) for images/videos with CDN (CloudFront) for delivery","Fan-out approach for feed: precompute feeds for users with few followers, on-demand for celebrities","Use Cassandra/DynamoDB for posts (high write throughput)","Redis for caching feeds and user sessions","Separate read and write paths for scalability","Use message queues (Kafka) for async operations like notifications"]'::jsonb,
  0,
  '["Facebook","Instagram","Twitter","Snapchat"]'::jsonb,
  60,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-parking-lot',
  'Design Parking Lot',
  'design-parking-lot',
  'medium',
  'Design a parking lot system that can handle different types of vehicles.

**Requirements:**
1. The parking lot has multiple levels
2. Each level has multiple parking spots
3. Parking spots can be of different sizes: Compact, Large, Motorcycle
4. Vehicles can be: Motorcycle, Car, Bus/Truck
5. A car can park in a single compact or large spot
6. A bus needs 5 consecutive large spots
7. A motorcycle can park in any spot

**Functionality:**
- Park a vehicle
- Remove a vehicle  
- Check availability
- Find nearest available spot
- Calculate parking fee based on time',
  '[{"input":"parkVehicle(new Car(\"ABC123\"))","output":"true (if spot available), returns spot number","explanation":"System finds an available compact or large spot and assigns it"}]'::jsonb,
  '["Support 1000+ parking spots","Real-time availability updates","Multiple entry/exit points","Concurrent vehicle parking/removal"]'::jsonb,
  '["Low Level Design","OOP","Design Patterns"]'::jsonb,
  'Low Level Design',
  '{"javascript":"class ParkingLot {\n  constructor(levels) {\n    // Your design here\n  }\n  \n  parkVehicle(vehicle) {\n    // Implementation\n  }\n  \n  removeVehicle(ticket) {\n    // Implementation\n  }\n}","python":"class ParkingLot:\n    def __init__(self, levels):\n        # Your design here\n        pass\n    \n    def park_vehicle(self, vehicle):\n        # Implementation\n        pass\n    \n    def remove_vehicle(self, ticket):\n        # Implementation\n        pass","java":"class ParkingLot {\n    private List<Level> levels;\n    \n    public ParkingLot(int numLevels, int spotsPerLevel) {\n        // Your design here\n    }\n    \n    public boolean parkVehicle(Vehicle vehicle) {\n        // Implementation\n    }\n    \n    public boolean removeVehicle(Ticket ticket) {\n        // Implementation\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use Strategy pattern for parking spot allocation","Use Observer pattern for availability notifications","Consider using a PriorityQueue for finding nearest spots","Create separate classes: Vehicle, ParkingSpot, Level, ParkingLot, Ticket","Use enum for VehicleType and SpotSize"]'::jsonb,
  0,
  '["Amazon","Microsoft","Google"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'singleton-pattern',
  'Implement Singleton Pattern',
  'singleton-pattern',
  'easy',
  'Implement the Singleton design pattern to ensure a class has only one instance and provide a global point of access to it.

**Requirements:**
1. Only one instance of the class should exist
2. Instance should be globally accessible
3. Instance should be created lazily (only when first needed)
4. Implementation should be thread-safe

**Common Use Cases:**
- Database connections
- Logger
- Configuration manager
- Cache

**Considerations:**
- Thread safety
- Lazy vs eager initialization
- Reflection attacks
- Serialization issues',
  '[{"input":"obj1 = Singleton.getInstance(); obj2 = Singleton.getInstance();","output":"obj1 === obj2 (true)","explanation":"Both references point to the same instance"}]'::jsonb,
  '["Must be thread-safe","Should handle lazy initialization","Prevent multiple instances through reflection","Handle serialization/deserialization correctly"]'::jsonb,
  '["Design Patterns","OOP","Creational Pattern"]'::jsonb,
  'Low Level Design',
  '{"javascript":"class Singleton {\n  constructor() {\n    // Prevent multiple instances\n  }\n  \n  static getInstance() {\n    // Return the single instance\n  }\n}","python":"class Singleton:\n    _instance = None\n    \n    def __new__(cls):\n        # Ensure single instance\n        pass\n    \n    @classmethod\n    def get_instance(cls):\n        # Return the single instance\n        pass","java":"public class Singleton {\n    private static volatile Singleton instance;\n    \n    private Singleton() {\n        // Private constructor\n    }\n    \n    public static Singleton getInstance() {\n        // Double-checked locking\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use static variable to hold the single instance","Make constructor private to prevent external instantiation","For thread safety in Java, use double-checked locking with volatile","In Python, override __new__ method","Consider using an enum in Java for the simplest thread-safe implementation"]'::jsonb,
  0,
  '["Amazon","Google","Microsoft"]'::jsonb,
  30,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'producer-consumer',
  'Producer-Consumer Problem',
  'producer-consumer',
  'medium',
  'Implement the classic Producer-Consumer problem using threads and synchronization.

**Problem:**
Producers generate data and place it in a shared buffer. Consumers take data from the buffer. The buffer has limited capacity.

**Requirements:**
1. Multiple producers and consumers
2. Shared fixed-size buffer (queue)
3. Producers wait if buffer is full
4. Consumers wait if buffer is empty
5. Thread-safe operations
6. No race conditions or deadlocks

**Synchronization Challenges:**
- Mutual exclusion (only one thread accesses buffer at a time)
- Producer must wait when buffer is full
- Consumer must wait when buffer is empty
- Notify waiting threads when conditions change',
  '[{"input":"Buffer size = 5, 2 producers, 3 consumers","output":"All items produced are consumed without data loss or corruption","explanation":"Producers and consumers coordinate access to shared buffer safely"}]'::jsonb,
  '["Buffer size: 1-100","Number of producers: 1-10","Number of consumers: 1-10","No item should be lost","No item should be processed twice"]'::jsonb,
  '["Operating Systems","Concurrency","Synchronization","Threads"]'::jsonb,
  'Operating Systems',
  '{"javascript":"class Buffer {\n  constructor(capacity) {\n    this.capacity = capacity;\n    this.queue = [];\n  }\n  \n  produce(item) {\n    // Add item to buffer (wait if full)\n  }\n  \n  consume() {\n    // Remove item from buffer (wait if empty)\n  }\n}","python":"import threading\n\nclass Buffer:\n    def __init__(self, capacity):\n        self.capacity = capacity\n        self.queue = []\n        self.lock = threading.Lock()\n        self.not_full = threading.Condition(self.lock)\n        self.not_empty = threading.Condition(self.lock)\n    \n    def produce(self, item):\n        # Add item to buffer\n        pass\n    \n    def consume(self):\n        # Remove item from buffer\n        pass","java":"class Buffer {\n    private Queue<Integer> queue;\n    private int capacity;\n    \n    public Buffer(int capacity) {\n        this.capacity = capacity;\n        this.queue = new LinkedList<>();\n    }\n    \n    public synchronized void produce(int item) throws InterruptedException {\n        // Add item to buffer\n    }\n    \n    public synchronized int consume() throws InterruptedException {\n        // Remove item from buffer\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use mutex/lock for mutual exclusion","Use condition variables (wait/notify) for coordination","Producer: lock → check if full → wait if full → add item → notify consumers → unlock","Consumer: lock → check if empty → wait if empty → remove item → notify producers → unlock","In Java, use synchronized keyword with wait() and notifyAll()"]'::jsonb,
  0,
  '["Google","Microsoft","Amazon"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-rate-limiter',
  'Design Rate Limiter',
  'design-rate-limiter',
  'medium',
  'Design a rate limiter that limits the number of requests a user can make to an API within a time window.

**Requirements:**
1. Limit requests per user per time window
2. Support different rate limiting strategies
3. Distribute across multiple servers
4. Low latency (< 10ms overhead)
5. Handle millions of users

**Rate Limiting Algorithms:**
- Token Bucket
- Leaky Bucket
- Fixed Window Counter
- Sliding Window Log
- Sliding Window Counter

**Key Decisions:**
- Where to store rate limit counters
- How to handle distributed systems
- What to do when limit is exceeded
- How to notify users of their limits',
  '[{"input":"User makes 10 requests in 1 second, limit is 5/second","output":"First 5 requests succeed, next 5 are rejected with 429 status","explanation":"Rate limiter blocks requests exceeding the threshold"}]'::jsonb,
  '["Support 100M+ users","Rate limit checks must be fast (< 10ms)","Distributed across multiple data centers","Handle various time windows: per second, minute, hour, day"]'::jsonb,
  '["System Design","Scalability","Redis","Algorithms"]'::jsonb,
  'System Design',
  '{"javascript":"// Design components:\n// 1. Rate limiting algorithm choice\n// 2. Storage mechanism (Redis)\n// 3. API middleware implementation\n// 4. Distributed coordination","python":"# Design components:\n# 1. Rate limiting algorithm choice\n# 2. Storage mechanism (Redis)\n# 3. API middleware implementation\n# 4. Distributed coordination","java":"// Design components:\n// 1. Rate limiting algorithm choice\n// 2. Storage mechanism (Redis)\n// 3. API middleware implementation\n// 4. Distributed coordination"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Token Bucket: Most flexible, allows bursts, tokens replenish at fixed rate","Use Redis with INCR and EXPIRE commands for distributed counting","Redis Lua scripts for atomic operations","Return rate limit info in headers: X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset","Consider using Redis Cluster for high availability"]'::jsonb,
  0,
  '["Stripe","Twitter","Shopify","Cloudflare"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-twitter',
  'Design Twitter',
  'design-twitter',
  'hard',
  'Design a simplified version of Twitter with core functionality.

**Core Features:**
1. Post tweets (280 characters)
2. Follow/unfollow users
3. Timeline: see tweets from followed users
4. Like and retweet
5. Trending topics
6. Search tweets
7. Mentions and hashtags

**Scale:**
- 500M users, 200M daily active users
- 500M tweets per day
- Average user follows 200 people
- Timeline should load in < 2 seconds

**Challenges:**
- Celebrity problem (users with millions of followers)
- Real-time timeline generation
- Trending topics calculation
- Search at scale',
  '[]'::jsonb,
  '["Handle 10,000 tweets per second","Timeline generation < 2 seconds","Search results < 1 second","Support global distribution"]'::jsonb,
  '["System Design","Scalability","Feed Generation","Search"]'::jsonb,
  'System Design',
  '{"javascript":"// Design components:\n// 1. Tweet service\n// 2. Timeline service (fan-out)\n// 3. Follow graph service\n// 4. Search service (Elasticsearch)\n// 5. Trending service\n// 6. Caching strategy","python":"# Design components:\n# 1. Tweet service\n# 2. Timeline service (fan-out)\n# 3. Follow graph service\n# 4. Search service (Elasticsearch)\n# 5. Trending service\n# 6. Caching strategy","java":"// Design components:\n// 1. Tweet service\n// 2. Timeline service (fan-out)\n# 3. Follow graph service\n// 4. Search service (Elasticsearch)\n// 5. Trending service\n// 6. Caching strategy"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use fan-out on write for regular users (push timeline to followers'' caches)","Use fan-out on read for celebrities (pull tweets when timeline requested)","Hybrid approach: fan-out for users with < 1M followers","Use Redis for caching timelines and user graphs","Use Cassandra for storing tweets (high write throughput)","Use Elasticsearch for tweet search","Use Kafka for streaming tweets to various services"]'::jsonb,
  0,
  '["Twitter","Facebook","LinkedIn"]'::jsonb,
  60,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'lru-cache-design',
  'Design LRU Cache',
  'lru-cache-design',
  'medium',
  'Design and implement an LRU (Least Recently Used) cache.

**Requirements:**
1. get(key): Get the value of the key if it exists, else return -1
2. put(key, value): Set or insert the value if key doesn''t exist
3. When cache reaches capacity, invalidate least recently used item
4. Both operations should be O(1) time complexity

**Functionality:**
- Track usage order of cache entries
- Evict least recently used when capacity reached
- Update usage order on both get and put
- Handle edge cases (capacity 0, negative keys, etc.)',
  '[{"input":"cache = LRUCache(2); cache.put(1,1); cache.put(2,2); cache.get(1); cache.put(3,3); cache.get(2);","output":"get(1) returns 1, get(2) returns -1 (evicted)","explanation":"When putting (3,3), capacity exceeded so (2,2) evicted as least recently used"}]'::jsonb,
  '["1 <= capacity <= 10000","0 <= key, value <= 100000","At most 100000 calls to get and put","Both get and put must be O(1)"]'::jsonb,
  '["Low Level Design","Data Structures","Hash Table","Linked List"]'::jsonb,
  'Low Level Design',
  '{"javascript":"class LRUCache {\n  constructor(capacity) {\n    this.capacity = capacity;\n    // Design your data structures\n  }\n  \n  get(key) {\n    // O(1) implementation\n  }\n  \n  put(key, value) {\n    // O(1) implementation\n  }\n}","python":"class LRUCache:\n    def __init__(self, capacity: int):\n        self.capacity = capacity\n        # Design your data structures\n        \n    def get(self, key: int) -> int:\n        # O(1) implementation\n        pass\n        \n    def put(self, key: int, value: int) -> None:\n        # O(1) implementation\n        pass","java":"class LRUCache {\n    private int capacity;\n    // Design your data structures\n    \n    public LRUCache(int capacity) {\n        this.capacity = capacity;\n    }\n    \n    public int get(int key) {\n        // O(1) implementation\n    }\n    \n    public void put(int key, int value) {\n        // O(1) implementation\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use HashMap for O(1) key lookups","Use Doubly Linked List to maintain order (most recent to least recent)","HashMap stores key -> Node reference","Move accessed node to front of list on get/put","Remove node from tail when capacity exceeded","Java: LinkedHashMap with accessOrder=true provides built-in LRU"]'::jsonb,
  0,
  '["Amazon","Google","Facebook","Microsoft"]'::jsonb,
  45,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'implement-http-server',
  'Implement HTTP Server',
  'implement-http-server',
  'hard',
  'Implement a basic HTTP/1.1 server from scratch that can handle HTTP requests and responses.

**Requirements:**
1. Parse HTTP requests (method, path, headers, body)
2. Route requests to appropriate handlers
3. Generate HTTP responses with status codes
4. Support GET, POST, PUT, DELETE methods
5. Handle multiple concurrent connections
6. Support keep-alive connections

**HTTP Request Format:**
```
GET /path HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0

```

**Response Format:**
```
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 13

Hello, World!
```',
  '[{"input":"Request: \"GET /api/users HTTP/1.1\\r\\nHost: localhost\\r\\n\\r\\n\"","output":"\"HTTP/1.1 200 OK\\r\\nContent-Type: application/json\\r\\n\\r\\n[...]\"","explanation":"Server parses request and returns appropriate response"}]'::jsonb,
  '["Handle concurrent connections (threading/async)","Parse headers correctly","Support chunked transfer encoding","Handle malformed requests gracefully"]'::jsonb,
  '["Computer Networks","HTTP","Sockets","Protocols"]'::jsonb,
  'Computer Networks',
  '{"javascript":"const net = require(''net'');\n\nclass HTTPServer {\n  constructor(port) {\n    this.port = port;\n    this.routes = new Map();\n  }\n  \n  parseRequest(data) {\n    // Parse HTTP request\n  }\n  \n  handleConnection(socket) {\n    // Handle incoming connection\n  }\n  \n  listen() {\n    // Start server\n  }\n}","python":"import socket\nimport threading\n\nclass HTTPServer:\n    def __init__(self, port):\n        self.port = port\n        self.routes = {}\n    \n    def parse_request(self, data):\n        # Parse HTTP request\n        pass\n    \n    def handle_connection(self, conn):\n        # Handle incoming connection\n        pass\n    \n    def listen(self):\n        # Start server\n        pass","java":"import java.net.*;\nimport java.io.*;\n\nclass HTTPServer {\n    private int port;\n    private Map<String, RequestHandler> routes;\n    \n    public HTTPServer(int port) {\n        this.port = port;\n        this.routes = new HashMap<>();\n    }\n    \n    private Request parseRequest(String data) {\n        // Parse HTTP request\n    }\n    \n    public void listen() {\n        // Start server\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use socket programming: create server socket, accept connections","Parse request line: split by space to get method, path, version","Parse headers: split by \\r\\n, then by : for key-value","Use threads or async I/O for concurrent connections","Implement Connection: keep-alive for persistent connections","Handle Content-Length to read request body"]'::jsonb,
  0,
  '["Google","Amazon","Microsoft"]'::jsonb,
  60,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'complex-joins',
  'Complex SQL Joins',
  'complex-joins',
  'medium',
  'Write complex SQL queries involving multiple joins to solve real-world problems.

**Problem:**
Given tables: `employees`, `departments`, `projects`, `employee_projects`, find:
1. Employees working on more than 3 projects
2. Departments with average salary > 75000
3. Projects with no assigned employees
4. Employees who work on all projects in their department

**Tables:**
```sql
employees (id, name, dept_id, salary, hire_date)
departments (id, name, budget)
projects (id, name, dept_id, deadline)
employee_projects (employee_id, project_id, hours_allocated)
```',
  '[{"input":"Query 1: Employees on 3+ projects","output":"List of employee names with project count","explanation":"Use JOIN with GROUP BY and HAVING"}]'::jsonb,
  '["Handle NULL values correctly","Optimize for large datasets (1M+ rows)","Use appropriate join types","Consider indexes for performance"]'::jsonb,
  '["Database","SQL","Joins","Aggregation"]'::jsonb,
  'Database',
  '{"javascript":"-- Query 1: Employees working on more than 3 projects\nSELECT \n  -- Your query here\nFROM employees e\n-- Add joins and conditions","python":"-- Query 1: Employees working on more than 3 projects\nSELECT \n  -- Your query here\nFROM employees e\n-- Add joins and conditions","java":"-- Query 1: Employees working on more than 3 projects\nSELECT \n  -- Your query here\nFROM employees e\n-- Add joins and conditions"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Query 1: INNER JOIN employee_projects, GROUP BY employee, HAVING COUNT(*) > 3","Query 2: JOIN departments, GROUP BY dept_id, HAVING AVG(salary) > 75000","Query 3: LEFT JOIN employee_projects WHERE employee_id IS NULL","Query 4: Use division operation or NOT EXISTS with double negative","Consider using CTEs (WITH clause) for readability"]'::jsonb,
  0,
  '["Google","Amazon","Facebook"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'linear-regression',
  'Implement Linear Regression',
  'linear-regression',
  'easy',
  'Implement linear regression from scratch without using ML libraries.

**Task:**
Given training data (X, y), find parameters θ that minimize the cost function:

Cost Function: J(θ) = (1/2m) Σ(hθ(x⁽ⁱ⁾) - y⁽ⁱ⁾)²

Where:
- hθ(x) = θ₀ + θ₁x₁ + θ₂x₂ + ... (hypothesis function)
- m = number of training examples

**Implement:**
1. Hypothesis function
2. Cost function
3. Gradient descent optimization
4. Prediction function

**Features:**
- Support multiple features
- Feature normalization
- Learning rate adjustment
- Convergence detection',
  '[{"input":"X = [[1], [2], [3]], y = [2, 4, 6], learning_rate = 0.01","output":"θ ≈ [0, 2] (y = 2x)","explanation":"Model learns the linear relationship between X and y"}]'::jsonb,
  '["Don''t use sklearn, TensorFlow, or similar ML libraries","Handle multiple features (n > 1)","Implement vectorized operations for efficiency","Support batch gradient descent"]'::jsonb,
  '["AI/ML","Machine Learning","Optimization","Gradient Descent"]'::jsonb,
  'AI/ML',
  '{"javascript":"class LinearRegression {\n  constructor(learningRate = 0.01, iterations = 1000) {\n    this.lr = learningRate;\n    this.iterations = iterations;\n    this.theta = null;\n  }\n  \n  fit(X, y) {\n    // Implement gradient descent\n  }\n  \n  predict(X) {\n    // Make predictions\n  }\n}","python":"import numpy as np\n\nclass LinearRegression:\n    def __init__(self, learning_rate=0.01, iterations=1000):\n        self.lr = learning_rate\n        self.iterations = iterations\n        self.theta = None\n    \n    def fit(self, X, y):\n        # Implement gradient descent\n        pass\n    \n    def predict(self, X):\n        # Make predictions\n        pass","java":"class LinearRegression {\n    private double learningRate;\n    private int iterations;\n    private double[] theta;\n    \n    public LinearRegression(double learningRate, int iterations) {\n        this.learningRate = learningRate;\n        this.iterations = iterations;\n    }\n    \n    public void fit(double[][] X, double[] y) {\n        // Implement gradient descent\n    }\n    \n    public double[] predict(double[][] X) {\n        // Make predictions\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Add bias term: prepend column of 1s to X matrix","Initialize θ to zeros","Gradient: ∂J/∂θⱼ = (1/m) Σ(hθ(x⁽ⁱ⁾) - y⁽ⁱ⁾)xⱼ⁽ⁱ⁾","Update rule: θⱼ := θⱼ - α(∂J/∂θⱼ)","Use vectorized form: θ := θ - (α/m)Xᵀ(Xθ - y)","Feature normalization: (x - mean) / std for faster convergence"]'::jsonb,
  0,
  '["Google","Amazon","Microsoft"]'::jsonb,
  45,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'implement-dns-resolver',
  'Implement DNS Resolver',
  'implement-dns-resolver',
  'hard',
  'Implement a DNS (Domain Name System) resolver that translates domain names to IP addresses.

**DNS Resolution Process:**
1. Check local cache
2. Query root nameserver (returns TLD nameserver)
3. Query TLD nameserver (returns authoritative nameserver)
4. Query authoritative nameserver (returns IP address)

**Requirements:**
- Recursive and iterative resolution
- DNS caching with TTL (Time To Live)
- Handle different record types (A, AAAA, CNAME, MX, NS)
- UDP protocol (512 bytes limit)
- Fallback to TCP for large responses

**DNS Packet Format:**
- Header: ID, Flags, Question Count, Answer Count
- Question Section: Domain, Type, Class
- Answer Section: Name, Type, Class, TTL, Data',
  '[{"input":"resolve(\"www.example.com\", \"A\")","output":"\"93.184.216.34\"","explanation":"Resolver queries DNS hierarchy and returns IPv4 address"}]'::jsonb,
  '["Handle DNS query timeout (5 seconds)","Cache responses according to TTL","Support DNS query retries","Parse DNS packet format correctly"]'::jsonb,
  '["Computer Networks","DNS","UDP","Protocols"]'::jsonb,
  'Computer Networks',
  '{"javascript":"class DNSResolver {\n  constructor() {\n    this.cache = new Map();\n    this.rootServers = [''198.41.0.4''];\n  }\n  \n  resolve(domain, recordType = ''A'') {\n    // Implement DNS resolution\n  }\n  \n  buildQuery(domain, type) {\n    // Build DNS query packet\n  }\n  \n  parseResponse(buffer) {\n    // Parse DNS response\n  }\n}","python":"import socket\nimport struct\n\nclass DNSResolver:\n    def __init__(self):\n        self.cache = {}\n        self.root_servers = [''198.41.0.4'']\n    \n    def resolve(self, domain, record_type=''A''):\n        # Implement DNS resolution\n        pass\n    \n    def build_query(self, domain, qtype):\n        # Build DNS query packet\n        pass\n    \n    def parse_response(self, data):\n        # Parse DNS response\n        pass","java":"import java.net.*;\nimport java.nio.*;\n\nclass DNSResolver {\n    private Map<String, CacheEntry> cache;\n    private String[] rootServers = {\"198.41.0.4\"};\n    \n    public String resolve(String domain, String recordType) {\n        // Implement DNS resolution\n    }\n    \n    private byte[] buildQuery(String domain, int type) {\n        // Build DNS query packet\n    }\n    \n    private DNSResponse parseResponse(byte[] data) {\n        // Parse DNS response\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["DNS uses port 53 (UDP)","Query ID is random 16-bit number for matching responses","Domain names are encoded as length-prefixed labels","Implement exponential backoff for retries","Cache should evict entries when TTL expires","Handle CNAME records by recursively resolving the canonical name"]'::jsonb,
  0,
  '["Google","Cloudflare","Amazon"]'::jsonb,
  60,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'tcp-congestion-control',
  'TCP Congestion Control',
  'tcp-congestion-control',
  'hard',
  'Implement TCP congestion control algorithms to manage network congestion.

**Congestion Control Phases:**
1. **Slow Start:** Exponentially increase cwnd until threshold
2. **Congestion Avoidance:** Linearly increase cwnd
3. **Fast Retransmit:** Detect packet loss via duplicate ACKs
4. **Fast Recovery:** Reduce cwnd and continue transmission

**Key Concepts:**
- cwnd (Congestion Window): Number of unacknowledged packets allowed
- ssthresh (Slow Start Threshold): Switch point between slow start and congestion avoidance
- RTT (Round Trip Time): Time for packet to reach destination and ACK to return

**Algorithms to Implement:**
- TCP Tahoe
- TCP Reno
- TCP NewReno
- TCP CUBIC (optional)',
  '[{"input":"Packet loss detected at cwnd=16, ssthresh=8","output":"cwnd=1, ssthresh=8 (Tahoe) or cwnd=8, ssthresh=8 (Reno)","explanation":"Different algorithms handle congestion differently"}]'::jsonb,
  '["Simulate packet transmission and ACKs","Handle packet loss scenarios","Track cwnd and ssthresh over time","Calculate throughput"]'::jsonb,
  '["Computer Networks","TCP","Congestion Control","Algorithms"]'::jsonb,
  'Computer Networks',
  '{"javascript":"class TCPCongestionControl {\n  constructor(algorithm = ''Reno'') {\n    this.cwnd = 1;\n    this.ssthresh = 64;\n    this.algorithm = algorithm;\n  }\n  \n  onAckReceived() {\n    // Update cwnd based on current phase\n  }\n  \n  onPacketLoss() {\n    // Handle congestion event\n  }\n  \n  getCurrentPhase() {\n    // Slow start or congestion avoidance\n  }\n}","python":"class TCPCongestionControl:\n    def __init__(self, algorithm=''Reno''):\n        self.cwnd = 1\n        self.ssthresh = 64\n        self.algorithm = algorithm\n    \n    def on_ack_received(self):\n        # Update cwnd based on current phase\n        pass\n    \n    def on_packet_loss(self):\n        # Handle congestion event\n        pass\n    \n    def get_current_phase(self):\n        # Slow start or congestion avoidance\n        pass","java":"class TCPCongestionControl {\n    private double cwnd;\n    private double ssthresh;\n    private String algorithm;\n    \n    public TCPCongestionControl(String algorithm) {\n        this.cwnd = 1;\n        this.ssthresh = 64;\n        this.algorithm = algorithm;\n    }\n    \n    public void onAckReceived() {\n        // Update cwnd\n    }\n    \n    public void onPacketLoss() {\n        // Handle congestion\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Slow Start: cwnd += 1 for each ACK (exponential growth)","Congestion Avoidance: cwnd += 1/cwnd for each ACK (linear growth)","TCP Tahoe: On loss, ssthresh = cwnd/2, cwnd = 1","TCP Reno: On 3 duplicate ACKs, ssthresh = cwnd/2, cwnd = ssthresh (fast recovery)","Fast retransmit: Retransmit packet after 3 duplicate ACKs","AIMD principle: Additive Increase, Multiplicative Decrease"]'::jsonb,
  0,
  '["Google","Facebook","Cloudflare"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'window-functions',
  'SQL Window Functions',
  'window-functions',
  'medium',
  'Master SQL window functions for advanced analytics and reporting.

**Window Functions:**
- **Ranking:** ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()
- **Aggregate:** SUM(), AVG(), COUNT(), MIN(), MAX() OVER()
- **Value:** LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE()

**Syntax:**
```sql
function() OVER (
  [PARTITION BY column]
  [ORDER BY column]
  [ROWS/RANGE BETWEEN ...]
)
```

**Problems to Solve:**
1. Find running total of sales by date
2. Calculate moving average (7-day window)
3. Rank employees by salary within department
4. Find first and last order of each customer
5. Calculate percentage of total revenue per product',
  '[{"input":"Table: sales (date, product, amount)","output":"Running total and 3-day moving average per product","explanation":"Use SUM() OVER() for running total, AVG() OVER(ROWS 2 PRECEDING) for moving average"}]'::jsonb,
  '["Optimize for large datasets","Handle NULL values correctly","Use appropriate window frames","Consider index usage"]'::jsonb,
  '["Database","SQL","Window Functions","Analytics"]'::jsonb,
  'Database',
  '{"javascript":"-- Problem 1: Running Total\nSELECT \n  date,\n  product,\n  amount,\n  SUM(amount) OVER (\n    PARTITION BY product \n    ORDER BY date\n  ) as running_total\nFROM sales;\n\n-- Problem 2: Moving Average\nSELECT \n  date,\n  amount,\n  AVG(amount) OVER (\n    ORDER BY date\n    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW\n  ) as moving_avg_7_day\nFROM sales;","python":"-- Problem 1: Running Total\nSELECT \n  date,\n  product,\n  amount,\n  SUM(amount) OVER (\n    PARTITION BY product \n    ORDER BY date\n  ) as running_total\nFROM sales;\n\n-- Problem 2: Moving Average\nSELECT \n  date,\n  amount,\n  AVG(amount) OVER (\n    ORDER BY date\n    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW\n  ) as moving_avg_7_day\nFROM sales;","java":"-- Problem 1: Running Total\nSELECT \n  date,\n  product,\n  amount,\n  SUM(amount) OVER (\n    PARTITION BY product \n    ORDER BY date\n  ) as running_total\nFROM sales;\n\n-- Problem 2: Moving Average\nSELECT \n  date,\n  amount,\n  AVG(amount) OVER (\n    ORDER BY date\n    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW\n  ) as moving_avg_7_day\nFROM sales;"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["PARTITION BY divides data into groups, similar to GROUP BY","ORDER BY defines the order for window operations","ROWS vs RANGE: ROWS counts physical rows, RANGE considers values","UNBOUNDED PRECEDING means all rows from start of partition","Use ROW_NUMBER() for unique ranking, RANK() allows ties","LAG(col, n) accesses value n rows before current row"]'::jsonb,
  0,
  '["Google","Amazon","Facebook"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'mongodb-aggregation',
  'MongoDB Aggregation Pipelines',
  'mongodb-aggregation',
  'medium',
  'Master MongoDB aggregation framework for complex data transformations and analytics.

**Aggregation Pipeline Stages:**
- **$match:** Filter documents
- **$group:** Group by field and calculate aggregates
- **$project:** Reshape documents, include/exclude fields
- **$sort:** Sort documents
- **$limit / $skip:** Pagination
- **$lookup:** Left outer join with another collection
- **$unwind:** Deconstruct array field
- **$facet:** Multiple aggregation pipelines

**Common Patterns:**
1. Calculate totals by category
2. Find top N items
3. Join collections and aggregate
4. Group by date ranges
5. Calculate percentiles and distributions',
  '[{"input":"Collection: orders { customer, product, amount, date }","output":"Top 10 customers by total spending with product breakdown","explanation":"Use $group to sum by customer, $sort and $limit for top 10"}]'::jsonb,
  '["Handle large datasets (millions of documents)","Optimize pipeline order for performance","Use indexes effectively","Handle nested documents and arrays"]'::jsonb,
  '["Database","NoSQL","MongoDB","Aggregation"]'::jsonb,
  'Database',
  '{"javascript":"// Problem 1: Total sales by category\ndb.orders.aggregate([\n  {\n    $group: {\n      _id: \"$category\",\n      totalSales: { $sum: \"$amount\" },\n      count: { $sum: 1 },\n      avgSale: { $avg: \"$amount\" }\n    }\n  },\n  { $sort: { totalSales: -1 } }\n]);\n\n// Problem 2: Join orders with customers\ndb.orders.aggregate([\n  {\n    $lookup: {\n      from: \"customers\",\n      localField: \"customerId\",\n      foreignField: \"_id\",\n      as: \"customerInfo\"\n    }\n  },\n  { $unwind: \"$customerInfo\" }\n]);","python":"# Problem 1: Total sales by category\ndb.orders.aggregate([\n  {\n    \"$group\": {\n      \"_id\": \"$category\",\n      \"totalSales\": { \"$sum\": \"$amount\" },\n      \"count\": { \"$sum\": 1 },\n      \"avgSale\": { \"$avg\": \"$amount\" }\n    }\n  },\n  { \"$sort\": { \"totalSales\": -1 } }\n])\n\n# Problem 2: Join orders with customers\ndb.orders.aggregate([\n  {\n    \"$lookup\": {\n      \"from\": \"customers\",\n      \"localField\": \"customerId\",\n      \"foreignField\": \"_id\",\n      \"as\": \"customerInfo\"\n    }\n  },\n  { \"$unwind\": \"$customerInfo\" }\n])","java":"// Problem 1: Total sales by category\ndb.getCollection(\"orders\").aggregate([\n  {\n    $group: {\n      _id: \"$category\",\n      totalSales: { $sum: \"$amount\" },\n      count: { $sum: 1 },\n      avgSale: { $avg: \"$amount\" }\n    }\n  },\n  { $sort: { totalSales: -1 } }\n]);\n\n// Problem 2: Join orders with customers\ndb.getCollection(\"orders\").aggregate([\n  {\n    $lookup: {\n      from: \"customers\",\n      localField: \"customerId\",\n      foreignField: \"_id\",\n      as: \"customerInfo\"\n    }\n  },\n  { $unwind: \"$customerInfo\" }\n]);"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Place $match early in pipeline to reduce documents processed","Use $project to exclude unnecessary fields and improve performance","$group _id can be a compound key: { category: ''$category'', year: ''$year'' }","$lookup is expensive - ensure indexed fields are used","$unwind creates a document for each array element","Use $facet for multiple aggregations in one query"]'::jsonb,
  0,
  '["MongoDB","Amazon","Google"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'logistic-regression',
  'Implement Logistic Regression',
  'logistic-regression',
  'medium',
  'Implement logistic regression for binary classification from scratch.

**Logistic Regression:**
Used for binary classification (y ∈ {0, 1})

**Hypothesis Function:**
hθ(x) = σ(θᵀx) = 1 / (1 + e^(-θᵀx))

Where σ is the sigmoid function

**Cost Function (Log Loss):**
J(θ) = -(1/m) Σ[y⁽ⁱ⁾log(hθ(x⁽ⁱ⁾)) + (1-y⁽ⁱ⁾)log(1-hθ(x⁽ⁱ⁾))]

**Gradient:**
∂J/∂θⱼ = (1/m) Σ(hθ(x⁽ⁱ⁾) - y⁽ⁱ⁾)xⱼ⁽ⁱ⁾

**Requirements:**
1. Implement sigmoid function
2. Implement cost function
3. Implement gradient descent
4. Implement prediction (threshold at 0.5)
5. Calculate accuracy, precision, recall',
  '[{"input":"X = [[0.5, 1.5], [1, 1], [1.5, 0.5]], y = [0, 1, 1]","output":"θ parameters that classify points correctly","explanation":"Model learns decision boundary separating classes"}]'::jsonb,
  '["Don''t use sklearn or similar ML libraries","Implement from scratch using NumPy only","Handle binary classification (0 or 1)","Support multiple features"]'::jsonb,
  '["AI/ML","Machine Learning","Classification","Gradient Descent"]'::jsonb,
  'AI/ML',
  '{"javascript":"class LogisticRegression {\n  constructor(learningRate = 0.01, iterations = 1000) {\n    this.lr = learningRate;\n    this.iterations = iterations;\n    this.theta = null;\n  }\n  \n  sigmoid(z) {\n    // Implement sigmoid: 1/(1+e^-z)\n  }\n  \n  fit(X, y) {\n    // Implement gradient descent\n  }\n  \n  predict(X, threshold = 0.5) {\n    // Predict class labels\n  }\n  \n  predictProba(X) {\n    // Return probabilities\n  }\n}","python":"import numpy as np\n\nclass LogisticRegression:\n    def __init__(self, learning_rate=0.01, iterations=1000):\n        self.lr = learning_rate\n        self.iterations = iterations\n        self.theta = None\n    \n    def sigmoid(self, z):\n        # Implement sigmoid: 1/(1+e^-z)\n        pass\n    \n    def fit(self, X, y):\n        # Implement gradient descent\n        pass\n    \n    def predict(self, X, threshold=0.5):\n        # Predict class labels\n        pass\n    \n    def predict_proba(self, X):\n        # Return probabilities\n        pass","java":"class LogisticRegression {\n    private double learningRate;\n    private int iterations;\n    private double[] theta;\n    \n    public LogisticRegression(double learningRate, int iterations) {\n        this.learningRate = learningRate;\n        this.iterations = iterations;\n    }\n    \n    private double sigmoid(double z) {\n        // Implement sigmoid\n    }\n    \n    public void fit(double[][] X, int[] y) {\n        // Implement gradient descent\n    }\n    \n    public int[] predict(double[][] X) {\n        // Predict class labels\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Sigmoid function: σ(z) = 1/(1+e^(-z)), maps any value to (0,1)","Add bias term: prepend column of 1s to X","Initialize θ to zeros","Vectorized gradient: ∂J/∂θ = (1/m)Xᵀ(σ(Xθ) - y)","Update rule: θ := θ - α∇J(θ)","Predict: return 1 if σ(θᵀx) ≥ 0.5, else 0","Use feature scaling for faster convergence"]'::jsonb,
  0,
  '["Google","Amazon","Microsoft"]'::jsonb,
  45,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'decision-trees',
  'Implement Decision Trees',
  'decision-trees',
  'medium',
  'Implement a decision tree classifier from scratch using ID3 or CART algorithm.

**Decision Tree Concepts:**
- **Root Node:** Top node representing entire dataset
- **Internal Nodes:** Decision points based on feature tests
- **Leaf Nodes:** Final predictions
- **Splitting:** Dividing dataset based on feature values

**Splitting Criteria:**
1. **Information Gain (ID3):** Uses entropy
   - Entropy: H(S) = -Σ p(c)log₂p(c)
   - Information Gain: IG = H(parent) - Σ(|child|/|parent|)H(child)

2. **Gini Impurity (CART):**
   - Gini: G(S) = 1 - Σ p(c)²
   - Choose split that minimizes weighted Gini

**Algorithm:**
1. Calculate impurity of current node
2. For each feature, find best split point
3. Choose feature/split with highest information gain
4. Recursively build left and right subtrees
5. Stop when max_depth reached or node is pure',
  '[{"input":"Features: [outlook, temp, humidity, windy], Target: play_tennis","output":"Decision tree with rules like \"if outlook=sunny and humidity=high then no\"","explanation":"Tree learns decision rules from training data"}]'::jsonb,
  '["Support both categorical and numerical features","Implement max_depth hyperparameter","Handle missing values","Implement pruning to avoid overfitting"]'::jsonb,
  '["AI/ML","Machine Learning","Classification","Trees"]'::jsonb,
  'AI/ML',
  '{"javascript":"class Node {\n  constructor(feature = null, threshold = null, left = null, right = null, value = null) {\n    this.feature = feature;\n    this.threshold = threshold;\n    this.left = left;\n    this.right = right;\n    this.value = value; // for leaf nodes\n  }\n}\n\nclass DecisionTree {\n  constructor(maxDepth = 10, minSamplesSplit = 2) {\n    this.maxDepth = maxDepth;\n    this.minSamplesSplit = minSamplesSplit;\n    this.root = null;\n  }\n  \n  entropy(y) {\n    // Calculate entropy\n  }\n  \n  informationGain(X, y, feature, threshold) {\n    // Calculate information gain\n  }\n  \n  fit(X, y) {\n    // Build tree\n  }\n  \n  predict(X) {\n    // Make predictions\n  }\n}","python":"import numpy as np\n\nclass Node:\n    def __init__(self, feature=None, threshold=None, left=None, right=None, value=None):\n        self.feature = feature\n        self.threshold = threshold\n        self.left = left\n        self.right = right\n        self.value = value\n\nclass DecisionTree:\n    def __init__(self, max_depth=10, min_samples_split=2):\n        self.max_depth = max_depth\n        self.min_samples_split = min_samples_split\n        self.root = None\n    \n    def entropy(self, y):\n        # Calculate entropy\n        pass\n    \n    def information_gain(self, X, y, feature, threshold):\n        # Calculate information gain\n        pass\n    \n    def fit(self, X, y):\n        # Build tree\n        pass\n    \n    def predict(self, X):\n        # Make predictions\n        pass","java":"class Node {\n    int feature;\n    double threshold;\n    Node left, right;\n    Integer value; // for leaf\n    \n    public Node(int feature, double threshold) {\n        this.feature = feature;\n        this.threshold = threshold;\n    }\n}\n\nclass DecisionTree {\n    private int maxDepth;\n    private int minSamplesSplit;\n    private Node root;\n    \n    public DecisionTree(int maxDepth, int minSamplesSplit) {\n        this.maxDepth = maxDepth;\n        this.minSamplesSplit = minSamplesSplit;\n    }\n    \n    private double entropy(int[] y) {\n        // Calculate entropy\n    }\n    \n    public void fit(double[][] X, int[] y) {\n        // Build tree\n    }\n    \n    public int[] predict(double[][] X) {\n        // Make predictions\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["For numerical features, try multiple threshold values (use midpoints)","For categorical features, try each unique value as split","Stop splitting when: max_depth reached, node is pure, or too few samples","Leaf node value is the majority class in that node","Information gain = entropy(parent) - weighted_average(entropy(children))","Gini impurity is often faster to compute than entropy"]'::jsonb,
  0,
  '["Google","Amazon","Facebook"]'::jsonb,
  60,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'cnn',
  'Convolutional Neural Networks',
  'cnn',
  'hard',
  'Implement a Convolutional Neural Network (CNN) from scratch for image classification.

**CNN Architecture:**
1. **Convolutional Layer:** Apply filters to extract features
2. **Activation (ReLU):** Non-linearity
3. **Pooling Layer:** Downsample (Max/Average pooling)
4. **Fully Connected Layer:** Final classification

**Key Operations:**

**Convolution:**
Output[i,j] = Σ Σ Input[i+m, j+n] × Kernel[m,n] + bias

**Max Pooling:**
Output[i,j] = max(Input[i:i+pool_size, j:j+pool_size])

**Backpropagation:**
- Gradient flows backward through network
- Update weights using gradient descent
- Chain rule for computing gradients

**Requirements:**
- Implement Conv2D layer with forward and backward pass
- Implement MaxPooling2D
- Implement Flatten and Dense layers
- Support multiple filters and channels
- Train on image dataset (e.g., MNIST)',
  '[{"input":"Input: 28×28 grayscale image","output":"Predicted digit class (0-9)","explanation":"CNN learns hierarchical features: edges → shapes → digits"}]'::jsonb,
  '["Implement without deep learning libraries (TensorFlow/PyTorch)","Use NumPy for matrix operations","Handle batched inputs","Support different kernel sizes and strides"]'::jsonb,
  '["AI/ML","Deep Learning","CNN","Computer Vision"]'::jsonb,
  'AI/ML',
  '{"javascript":"class Conv2D {\n  constructor(numFilters, kernelSize, inputChannels) {\n    this.numFilters = numFilters;\n    this.kernelSize = kernelSize;\n    this.filters = this.initWeights(numFilters, kernelSize, inputChannels);\n  }\n  \n  forward(input) {\n    // Implement convolution\n  }\n  \n  backward(dout, learningRate) {\n    // Implement backpropagation\n  }\n}\n\nclass MaxPool2D {\n  constructor(poolSize = 2) {\n    this.poolSize = poolSize;\n  }\n  \n  forward(input) {\n    // Implement max pooling\n  }\n  \n  backward(dout) {\n    // Backprop through pooling\n  }\n}\n\nclass CNN {\n  constructor() {\n    this.layers = [];\n  }\n  \n  addLayer(layer) {\n    this.layers.push(layer);\n  }\n  \n  forward(X) {\n    // Forward pass through all layers\n  }\n  \n  train(X, y, epochs, lr) {\n    // Training loop\n  }\n}","python":"import numpy as np\n\nclass Conv2D:\n    def __init__(self, num_filters, kernel_size, input_channels):\n        self.num_filters = num_filters\n        self.kernel_size = kernel_size\n        # Initialize weights\n        self.filters = np.random.randn(num_filters, input_channels, kernel_size, kernel_size) * 0.1\n        self.bias = np.zeros(num_filters)\n    \n    def forward(self, input):\n        # Implement convolution\n        pass\n    \n    def backward(self, dout, learning_rate):\n        # Implement backpropagation\n        pass\n\nclass MaxPool2D:\n    def __init__(self, pool_size=2):\n        self.pool_size = pool_size\n    \n    def forward(self, input):\n        # Implement max pooling\n        pass\n    \n    def backward(self, dout):\n        # Backprop through pooling\n        pass\n\nclass CNN:\n    def __init__(self):\n        self.layers = []\n    \n    def add_layer(self, layer):\n        self.layers.append(layer)\n    \n    def forward(self, X):\n        # Forward pass\n        pass\n    \n    def train(self, X, y, epochs, lr):\n        # Training loop\n        pass","java":"class Conv2D {\n    private double[][][][] filters; // [numFilters][inputChannels][kernelSize][kernelSize]\n    private double[] bias;\n    \n    public Conv2D(int numFilters, int kernelSize, int inputChannels) {\n        // Initialize weights\n    }\n    \n    public double[][][] forward(double[][][] input) {\n        // Implement convolution\n    }\n    \n    public void backward(double[][][] dout, double learningRate) {\n        // Implement backpropagation\n    }\n}\n\nclass MaxPool2D {\n    private int poolSize;\n    \n    public MaxPool2D(int poolSize) {\n        this.poolSize = poolSize;\n    }\n    \n    public double[][][] forward(double[][][] input) {\n        // Implement max pooling\n    }\n    \n    public double[][][] backward(double[][][] dout) {\n        // Backprop through pooling\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Convolution: slide kernel over input, compute dot product at each position","Output size: (input_size - kernel_size + 2×padding) / stride + 1","Use im2col transformation for efficient convolution","Max pooling: remember indices of max values for backprop","Xavier initialization: weights ~ N(0, 2/(n_in + n_out))","Use ReLU activation: max(0, x) for faster training","Batch normalization helps with training stability"]'::jsonb,
  0,
  '["Google","Facebook","NVIDIA","OpenAI"]'::jsonb,
  90,
  512
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'lstm',
  'LSTM Networks',
  'lstm',
  'hard',
  'Implement Long Short-Term Memory (LSTM) networks from scratch for sequence modeling.

**LSTM Architecture:**
LSTM solves vanishing gradient problem in RNNs using gated cells.

**Gates (at each time step t):**

1. **Forget Gate:** What to forget from cell state
   fₜ = σ(Wf·[hₜ₋₁, xₜ] + bf)

2. **Input Gate:** What new info to store
   iₜ = σ(Wi·[hₜ₋₁, xₜ] + bi)
   C̃ₜ = tanh(Wc·[hₜ₋₁, xₜ] + bc)

3. **Cell State Update:**
   Cₜ = fₜ ⊙ Cₜ₋₁ + iₜ ⊙ C̃ₜ

4. **Output Gate:** What to output
   oₜ = σ(Wo·[hₜ₋₁, xₜ] + bo)
   hₜ = oₜ ⊙ tanh(Cₜ)

Where:
- σ = sigmoid function
- ⊙ = element-wise multiplication
- hₜ = hidden state
- Cₜ = cell state',
  '[{"input":"Sequence: [1, 2, 3, 4, 5]","output":"Next value: 6","explanation":"LSTM learns temporal dependencies in sequence data"}]'::jsonb,
  '["Implement forward pass with all gates","Implement backpropagation through time (BPTT)","Handle variable sequence lengths","Support multiple layers"]'::jsonb,
  '["AI/ML","Deep Learning","RNN","Sequence Modeling"]'::jsonb,
  'AI/ML',
  '{"javascript":"class LSTMCell {\n  constructor(inputSize, hiddenSize) {\n    this.inputSize = inputSize;\n    this.hiddenSize = hiddenSize;\n    \n    // Initialize weights for forget, input, output gates and cell\n    this.Wf = this.initWeights(hiddenSize, inputSize + hiddenSize);\n    this.Wi = this.initWeights(hiddenSize, inputSize + hiddenSize);\n    this.Wo = this.initWeights(hiddenSize, inputSize + hiddenSize);\n    this.Wc = this.initWeights(hiddenSize, inputSize + hiddenSize);\n    \n    // Biases\n    this.bf = new Array(hiddenSize).fill(0);\n    this.bi = new Array(hiddenSize).fill(0);\n    this.bo = new Array(hiddenSize).fill(0);\n    this.bc = new Array(hiddenSize).fill(0);\n  }\n  \n  forward(x, hPrev, cPrev) {\n    // Implement LSTM forward pass\n    // Return h_next, c_next\n  }\n  \n  backward(dh, dc, cache) {\n    // Implement BPTT\n  }\n}\n\nclass LSTM {\n  constructor(inputSize, hiddenSize, outputSize) {\n    this.cell = new LSTMCell(inputSize, hiddenSize);\n    this.Wy = this.initWeights(outputSize, hiddenSize);\n    this.by = new Array(outputSize).fill(0);\n  }\n  \n  forward(inputs) {\n    // Process sequence\n  }\n  \n  train(X, y, epochs, lr) {\n    // Training loop\n  }\n}","python":"import numpy as np\n\nclass LSTMCell:\n    def __init__(self, input_size, hidden_size):\n        self.input_size = input_size\n        self.hidden_size = hidden_size\n        \n        # Initialize weights\n        self.Wf = np.random.randn(hidden_size, input_size + hidden_size) * 0.01\n        self.Wi = np.random.randn(hidden_size, input_size + hidden_size) * 0.01\n        self.Wo = np.random.randn(hidden_size, input_size + hidden_size) * 0.01\n        self.Wc = np.random.randn(hidden_size, input_size + hidden_size) * 0.01\n        \n        # Biases\n        self.bf = np.zeros((hidden_size, 1))\n        self.bi = np.zeros((hidden_size, 1))\n        self.bo = np.zeros((hidden_size, 1))\n        self.bc = np.zeros((hidden_size, 1))\n    \n    def forward(self, x, h_prev, c_prev):\n        # Implement LSTM forward pass\n        # Concatenate h_prev and x\n        combined = np.vstack((h_prev, x))\n        \n        # Compute gates\n        # f_t = sigmoid(Wf @ combined + bf)\n        # i_t = sigmoid(Wi @ combined + bi)\n        # c_tilde = tanh(Wc @ combined + bc)\n        # c_next = f_t * c_prev + i_t * c_tilde\n        # o_t = sigmoid(Wo @ combined + bo)\n        # h_next = o_t * tanh(c_next)\n        \n        pass\n    \n    def backward(self, dh_next, dc_next, cache):\n        # Implement BPTT\n        pass\n\nclass LSTM:\n    def __init__(self, input_size, hidden_size, output_size):\n        self.cell = LSTMCell(input_size, hidden_size)\n        self.Wy = np.random.randn(output_size, hidden_size) * 0.01\n        self.by = np.zeros((output_size, 1))\n    \n    def forward(self, inputs):\n        # Process sequence\n        pass\n    \n    def train(self, X, y, epochs, lr):\n        # Training loop\n        pass","java":"class LSTMCell {\n    private double[][] Wf, Wi, Wo, Wc;\n    private double[] bf, bi, bo, bc;\n    private int inputSize, hiddenSize;\n    \n    public LSTMCell(int inputSize, int hiddenSize) {\n        this.inputSize = inputSize;\n        this.hiddenSize = hiddenSize;\n        // Initialize weights\n    }\n    \n    public LSTMState forward(double[] x, double[] hPrev, double[] cPrev) {\n        // Implement LSTM forward pass\n    }\n    \n    public void backward(double[] dh, double[] dc, Object cache) {\n        // Implement BPTT\n    }\n}\n\nclass LSTM {\n    private LSTMCell cell;\n    private double[][] Wy;\n    private double[] by;\n    \n    public LSTM(int inputSize, int hiddenSize, int outputSize) {\n        this.cell = new LSTMCell(inputSize, hiddenSize);\n        // Initialize output weights\n    }\n    \n    public double[][] forward(double[][] inputs) {\n        // Process sequence\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Sigmoid gates (f, i, o) control information flow","Tanh squashes values to [-1, 1]","Cell state C acts as memory highway","Forget gate typically initialized with bias = 1 (remember by default)","Gradient clipping prevents exploding gradients","Use Xavier/He initialization for weights","Cache intermediate values during forward pass for backprop"]'::jsonb,
  0,
  '["Google","DeepMind","OpenAI","Facebook"]'::jsonb,
  90,
  512
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'implement-load-balancer',
  'Implement Load Balancer',
  'implement-load-balancer',
  'hard',
  'Implement a load balancer that distributes incoming requests across multiple backend servers.

**Load Balancing Algorithms:**
1. **Round Robin:** Distribute requests sequentially
2. **Least Connections:** Route to server with fewest active connections
3. **Weighted Round Robin:** Assign weights based on server capacity
4. **IP Hash:** Use client IP to determine server (session persistence)
5. **Least Response Time:** Route to fastest responding server

**Key Features:**
- Health checks: Monitor server availability
- Connection pooling: Reuse connections
- Retry logic: Handle server failures
- Session persistence (sticky sessions)
- SSL termination
- Request/Response logging

**Implementation Requirements:**
- Accept incoming TCP/HTTP connections
- Maintain pool of backend servers
- Distribute load based on algorithm
- Handle server failures gracefully
- Track active connections per server',
  '[{"input":"Servers: [server1:8001, server2:8002, server3:8003], Algorithm: Round Robin","output":"Request 1→server1, Request 2→server2, Request 3→server3, Request 4→server1...","explanation":"Load balancer cycles through servers sequentially"}]'::jsonb,
  '["Handle 10,000+ concurrent connections","Health check every 5 seconds","Automatic failover when server down","Support HTTP/1.1 and keep-alive"]'::jsonb,
  '["Computer Networks","Load Balancing","Distributed Systems"]'::jsonb,
  'Computer Networks',
  '{"javascript":"class LoadBalancer {\n  constructor(algorithm = ''round-robin'') {\n    this.servers = [];\n    this.algorithm = algorithm;\n    this.currentIndex = 0;\n    this.connections = new Map();\n  }\n  \n  addServer(host, port) {\n    this.servers.push({ host, port, healthy: true, connections: 0 });\n  }\n  \n  getNextServer() {\n    // Implement load balancing algorithm\n  }\n  \n  healthCheck() {\n    // Check server health periodically\n  }\n  \n  handleRequest(request) {\n    // Route request to appropriate server\n  }\n}","python":"import socket\nimport threading\n\nclass LoadBalancer:\n    def __init__(self, algorithm=''round-robin''):\n        self.servers = []\n        self.algorithm = algorithm\n        self.current_index = 0\n        self.connections = {}\n    \n    def add_server(self, host, port):\n        self.servers.append({\n            ''host'': host,\n            ''port'': port,\n            ''healthy'': True,\n            ''connections'': 0\n        })\n    \n    def get_next_server(self):\n        # Implement load balancing algorithm\n        pass\n    \n    def health_check(self):\n        # Check server health periodically\n        pass\n    \n    def handle_request(self, request):\n        # Route request to appropriate server\n        pass","java":"import java.net.*;\nimport java.util.*;\n\nclass Server {\n    String host;\n    int port;\n    boolean healthy;\n    int connections;\n}\n\nclass LoadBalancer {\n    private List<Server> servers;\n    private String algorithm;\n    private int currentIndex;\n    \n    public LoadBalancer(String algorithm) {\n        this.servers = new ArrayList<>();\n        this.algorithm = algorithm;\n        this.currentIndex = 0;\n    }\n    \n    public void addServer(String host, int port) {\n        // Add server to pool\n    }\n    \n    public Server getNextServer() {\n        // Implement load balancing algorithm\n    }\n    \n    public void healthCheck() {\n        // Check server health\n    }\n    \n    public void handleRequest(Socket client) {\n        // Route request\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Round Robin: Use modulo operator to cycle through servers","Least Connections: Track active connections per server, choose minimum","Health Check: Send TCP SYN or HTTP GET request, mark unhealthy if timeout","Skip unhealthy servers when selecting next server","Use connection pooling to avoid creating new connections for each request","Implement exponential backoff for retrying failed servers"]'::jsonb,
  0,
  '["NGINX","HAProxy","AWS","Cloudflare"]'::jsonb,
  60,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'socket-programming',
  'Socket Programming Basics',
  'socket-programming',
  'medium',
  'Implement basic client-server communication using TCP sockets.

**Socket Programming Concepts:**

**Server Side:**
1. Create socket: `socket(AF_INET, SOCK_STREAM)`
2. Bind to address/port: `bind(address, port)`
3. Listen for connections: `listen(backlog)`
4. Accept connections: `accept()` (blocking)
5. Send/Receive data: `send()`, `recv()`
6. Close connection: `close()`

**Client Side:**
1. Create socket
2. Connect to server: `connect(address, port)`
3. Send/Receive data
4. Close connection

**Tasks:**
1. Implement echo server (echoes back received data)
2. Implement chat server (broadcast messages to all clients)
3. Handle multiple clients concurrently (threading/async)
4. Implement simple protocol (length-prefixed messages)',
  '[{"input":"Client sends: \"Hello Server\"","output":"Server echoes: \"Hello Server\"","explanation":"Basic echo server functionality"}]'::jsonb,
  '["Handle multiple concurrent clients","Graceful connection termination","Handle partial reads/writes","Support both IPv4 and IPv6"]'::jsonb,
  '["Computer Networks","Sockets","TCP","Client-Server"]'::jsonb,
  'Computer Networks',
  '{"javascript":"const net = require(''net'');\n\n// Echo Server\nconst server = net.createServer((socket) => {\n  console.log(''Client connected'');\n  \n  socket.on(''data'', (data) => {\n    // Echo back to client\n    socket.write(data);\n  });\n  \n  socket.on(''end'', () => {\n    console.log(''Client disconnected'');\n  });\n});\n\nserver.listen(8080, () => {\n  console.log(''Server listening on port 8080'');\n});\n\n// Client\nconst client = net.createConnection({ port: 8080 }, () => {\n  console.log(''Connected to server'');\n  client.write(''Hello Server'');\n});\n\nclient.on(''data'', (data) => {\n  console.log(''Received:'', data.toString());\n  client.end();\n});","python":"import socket\nimport threading\n\n# Echo Server\ndef handle_client(conn, addr):\n    print(f''Connected by {addr}'')\n    while True:\n        data = conn.recv(1024)\n        if not data:\n            break\n        conn.sendall(data)  # Echo back\n    conn.close()\n\ndef start_server(host=''127.0.0.1'', port=8080):\n    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:\n        s.bind((host, port))\n        s.listen()\n        print(f''Server listening on {host}:{port}'')\n        \n        while True:\n            conn, addr = s.accept()\n            thread = threading.Thread(target=handle_client, args=(conn, addr))\n            thread.start()\n\n# Client\ndef start_client(host=''127.0.0.1'', port=8080):\n    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:\n        s.connect((host, port))\n        s.sendall(b''Hello Server'')\n        data = s.recv(1024)\n        print(f''Received: {data.decode()}'')\n\nif __name__ == ''__main__'':\n    # Run server in main thread\n    start_server()","java":"import java.net.*;\nimport java.io.*;\n\n// Echo Server\nclass EchoServer {\n    public static void main(String[] args) throws IOException {\n        ServerSocket serverSocket = new ServerSocket(8080);\n        System.out.println(\"Server listening on port 8080\");\n        \n        while (true) {\n            Socket clientSocket = serverSocket.accept();\n            new Thread(new ClientHandler(clientSocket)).start();\n        }\n    }\n}\n\nclass ClientHandler implements Runnable {\n    private Socket socket;\n    \n    public ClientHandler(Socket socket) {\n        this.socket = socket;\n    }\n    \n    public void run() {\n        try {\n            BufferedReader in = new BufferedReader(\n                new InputStreamReader(socket.getInputStream()));\n            PrintWriter out = new PrintWriter(\n                socket.getOutputStream(), true);\n            \n            String line;\n            while ((line = in.readLine()) != null) {\n                out.println(line);  // Echo back\n            }\n            socket.close();\n        } catch (IOException e) {\n            e.printStackTrace();\n        }\n    }\n}\n\n// Client\nclass EchoClient {\n    public static void main(String[] args) throws IOException {\n        Socket socket = new Socket(\"localhost\", 8080);\n        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);\n        BufferedReader in = new BufferedReader(\n            new InputStreamReader(socket.getInputStream()));\n        \n        out.println(\"Hello Server\");\n        System.out.println(\"Received: \" + in.readLine());\n        socket.close();\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use threading or async I/O to handle multiple clients","Set socket options: SO_REUSEADDR for quick restart","Handle partial reads: recv() may not return all data at once","Use try-finally to ensure sockets are closed","For chat server, maintain list of connected clients","Implement message framing: length-prefix or delimiter-based"]'::jsonb,
  0,
  '["Google","Amazon","Microsoft"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'query-optimization',
  'SQL Query Optimization',
  'query-optimization',
  'hard',
  'Learn techniques to optimize slow SQL queries for better performance.

**Query Optimization Techniques:**

**1. Index Optimization:**
- Create indexes on WHERE, JOIN, ORDER BY columns
- Use composite indexes for multiple columns
- Avoid functions on indexed columns

**2. Query Rewriting:**
- Replace subqueries with JOINs
- Use EXISTS instead of IN for large datasets
- Avoid SELECT *, specify needed columns

**3. Execution Plan Analysis:**
- Use EXPLAIN to analyze query plan
- Look for full table scans
- Check index usage
- Identify bottlenecks

**4. Join Optimization:**
- Smaller tables first in JOIN order
- Use appropriate join type (INNER, LEFT, etc.)
- Filter early with WHERE clauses

**5. Avoid Common Anti-Patterns:**
- N+1 query problem
- Using OR on different columns (consider UNION)
- Using LIKE with leading wildcard (%value)
- NOT IN with NULLs',
  '[{"input":"Slow: SELECT * FROM orders WHERE YEAR(date) = 2024","output":"Fast: SELECT * FROM orders WHERE date >= \"2024-01-01\" AND date < \"2025-01-01\"","explanation":"Avoid functions on indexed columns to use index"},{"input":"Slow: SELECT * FROM users WHERE id IN (SELECT user_id FROM orders)","output":"Fast: SELECT DISTINCT u.* FROM users u INNER JOIN orders o ON u.id = o.user_id","explanation":"JOIN is typically faster than IN subquery"}]'::jsonb,
  '["Optimize queries running > 1 second","Reduce table scans","Improve index utilization","Handle millions of rows efficiently"]'::jsonb,
  '["Database","SQL","Performance","Optimization"]'::jsonb,
  'Database',
  '{"javascript":"-- Problem: Optimize this slow query\n-- Slow version\nSELECT *\nFROM orders o\nWHERE o.user_id IN (\n    SELECT u.id \n    FROM users u \n    WHERE u.country = ''USA''\n)\nAND YEAR(o.order_date) = 2024\nORDER BY o.total DESC;\n\n-- Your optimized version:\n-- 1. Replace IN subquery with JOIN\n-- 2. Remove function on indexed column\n-- 3. Select only needed columns\n-- 4. Add appropriate indexes\n\nSELECT o.id, o.user_id, o.order_date, o.total\nFROM orders o\nINNER JOIN users u ON o.user_id = u.id\nWHERE u.country = ''USA''\n  AND o.order_date >= ''2024-01-01''\n  AND o.order_date < ''2025-01-01''\nORDER BY o.total DESC;\n\n-- Recommended indexes:\nCREATE INDEX idx_users_country ON users(country);\nCREATE INDEX idx_orders_date_total ON orders(order_date, total);\nCREATE INDEX idx_orders_user_id ON orders(user_id);","python":"-- Problem: Optimize this slow query\n-- Slow version\nSELECT *\nFROM orders o\nWHERE o.user_id IN (\n    SELECT u.id \n    FROM users u \n    WHERE u.country = ''USA''\n)\nAND YEAR(o.order_date) = 2024\nORDER BY o.total DESC;\n\n-- Your optimized version:\nSELECT o.id, o.user_id, o.order_date, o.total\nFROM orders o\nINNER JOIN users u ON o.user_id = u.id\nWHERE u.country = ''USA''\n  AND o.order_date >= ''2024-01-01''\n  AND o.order_date < ''2025-01-01''\nORDER BY o.total DESC;\n\n-- Recommended indexes:\nCREATE INDEX idx_users_country ON users(country);\nCREATE INDEX idx_orders_date_total ON orders(order_date, total);\nCREATE INDEX idx_orders_user_id ON orders(user_id);","java":"-- Problem: Optimize this slow query\n-- Slow version\nSELECT *\nFROM orders o\nWHERE o.user_id IN (\n    SELECT u.id \n    FROM users u \n    WHERE u.country = ''USA''\n)\nAND YEAR(o.order_date) = 2024\nORDER BY o.total DESC;\n\n-- Your optimized version:\nSELECT o.id, o.user_id, o.order_date, o.total\nFROM orders o\nINNER JOIN users u ON o.user_id = u.id\nWHERE u.country = ''USA''\n  AND o.order_date >= ''2024-01-01''\n  AND o.order_date < ''2025-01-01''\nORDER BY o.total DESC;\n\n-- Recommended indexes:\nCREATE INDEX idx_users_country ON users(country);\nCREATE INDEX idx_orders_date_total ON orders(order_date, total);\nCREATE INDEX idx_orders_user_id ON orders(user_id);"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use EXPLAIN ANALYZE to see actual execution times","Look for ''Seq Scan'' in plan - indicates missing index","Covering index: index contains all columns needed (no table lookup)","Denormalization can improve read performance","Partition large tables by date ranges","Use query result caching (Redis) for frequently accessed data","Batch updates/inserts instead of row-by-row operations"]'::jsonb,
  0,
  '["Google","Amazon","Facebook","Netflix"]'::jsonb,
  60,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'redis-caching',
  'Redis Caching Strategies',
  'redis-caching',
  'medium',
  'Implement effective caching strategies using Redis to improve application performance.

**Redis Data Structures:**
- **Strings:** Simple key-value (most common for caching)
- **Hashes:** Store objects with multiple fields
- **Lists:** Queues, recent items
- **Sets:** Unique items, tags
- **Sorted Sets:** Leaderboards, rankings

**Caching Patterns:**

**1. Cache-Aside (Lazy Loading):**
```
1. Check cache for data
2. If miss, fetch from DB
3. Store in cache with TTL
4. Return data
```

**2. Write-Through:**
```
1. Write to cache
2. Write to database
3. Cache always in sync
```

**3. Write-Behind:**
```
1. Write to cache immediately
2. Async write to DB (batched)
3. Better write performance
```

**Cache Invalidation:**
- TTL (Time To Live)
- Manual invalidation on updates
- Cache warming (pre-populate)

**Use Cases:**
- Session storage
- API response caching
- Database query results
- Rate limiting counters
- Leaderboards',
  '[{"input":"getUserProfile(userId)","output":"Check Redis → if miss, query DB → cache result → return","explanation":"Cache-aside pattern reduces database load"}]'::jsonb,
  '["Set appropriate TTL values","Handle cache stampede (thundering herd)","Implement cache warming for hot keys","Monitor cache hit ratio"]'::jsonb,
  '["Database","Redis","Caching","Performance"]'::jsonb,
  'Database',
  '{"javascript":"const redis = require(''redis'');\nconst client = redis.createClient();\n\n// Cache-Aside Pattern\nasync function getUserProfile(userId) {\n  const cacheKey = `user:${userId}`;\n  \n  // Try cache first\n  const cached = await client.get(cacheKey);\n  if (cached) {\n    return JSON.parse(cached);\n  }\n  \n  // Cache miss - fetch from DB\n  const user = await db.query(''SELECT * FROM users WHERE id = ?'', [userId]);\n  \n  // Store in cache with 1 hour TTL\n  await client.setEx(cacheKey, 3600, JSON.stringify(user));\n  \n  return user;\n}\n\n// Invalidate cache on update\nasync function updateUserProfile(userId, data) {\n  await db.query(''UPDATE users SET ? WHERE id = ?'', [data, userId]);\n  await client.del(`user:${userId}`);\n}\n\n// Cache complex queries\nasync function getTopProducts() {\n  const cacheKey = ''top_products'';\n  \n  const cached = await client.get(cacheKey);\n  if (cached) return JSON.parse(cached);\n  \n  const products = await db.query(\n    ''SELECT * FROM products ORDER BY sales DESC LIMIT 10''\n  );\n  \n  await client.setEx(cacheKey, 300, JSON.stringify(products)); // 5 min\n  return products;\n}","python":"import redis\nimport json\n\nr = redis.Redis(host=''localhost'', port=6379, decode_responses=True)\n\n# Cache-Aside Pattern\ndef get_user_profile(user_id):\n    cache_key = f''user:{user_id}''\n    \n    # Try cache first\n    cached = r.get(cache_key)\n    if cached:\n        return json.loads(cached)\n    \n    # Cache miss - fetch from DB\n    user = db.query(''SELECT * FROM users WHERE id = %s'', (user_id,))\n    \n    # Store in cache with 1 hour TTL\n    r.setex(cache_key, 3600, json.dumps(user))\n    \n    return user\n\n# Invalidate cache on update\ndef update_user_profile(user_id, data):\n    db.query(''UPDATE users SET ... WHERE id = %s'', (user_id,))\n    r.delete(f''user:{user_id}'')\n\n# Cache with hash (for objects)\ndef cache_user_hash(user_id, user_data):\n    cache_key = f''user:{user_id}''\n    r.hset(cache_key, mapping=user_data)\n    r.expire(cache_key, 3600)\n\ndef get_user_field(user_id, field):\n    return r.hget(f''user:{user_id}'', field)\n\n# Rate limiting with Redis\ndef is_rate_limited(user_id, limit=100, window=60):\n    key = f''rate:{user_id}''\n    count = r.incr(key)\n    if count == 1:\n        r.expire(key, window)\n    return count > limit","java":"import redis.clients.jedis.Jedis;\nimport com.fasterxml.jackson.databind.ObjectMapper;\n\nclass CacheService {\n    private Jedis jedis;\n    private ObjectMapper mapper;\n    \n    public CacheService() {\n        this.jedis = new Jedis(\"localhost\", 6379);\n        this.mapper = new ObjectMapper();\n    }\n    \n    // Cache-Aside Pattern\n    public User getUserProfile(int userId) throws Exception {\n        String cacheKey = \"user:\" + userId;\n        \n        // Try cache first\n        String cached = jedis.get(cacheKey);\n        if (cached != null) {\n            return mapper.readValue(cached, User.class);\n        }\n        \n        // Cache miss - fetch from DB\n        User user = db.queryUser(userId);\n        \n        // Store in cache with 1 hour TTL\n        jedis.setex(cacheKey, 3600, mapper.writeValueAsString(user));\n        \n        return user;\n    }\n    \n    // Invalidate cache\n    public void updateUserProfile(int userId, User data) {\n        db.updateUser(userId, data);\n        jedis.del(\"user:\" + userId);\n    }\n    \n    // Use Redis hash for objects\n    public void cacheUserHash(int userId, Map<String, String> userData) {\n        String key = \"user:\" + userId;\n        jedis.hset(key, userData);\n        jedis.expire(key, 3600);\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Use Redis pipelining for multiple operations","Implement circuit breaker for Redis failures (fallback to DB)","Use Redis Cluster for high availability","Monitor cache hit ratio: hits / (hits + misses)","For hot keys, use local in-memory cache + Redis","Implement cache stampede protection: lock/semaphore during fetch","Use Redis pub/sub for cache invalidation across servers"]'::jsonb,
  0,
  '["Redis","Amazon","Twitter","Stack Overflow"]'::jsonb,
  45,
  0
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'naive-bayes',
  'Naive Bayes Classifier',
  'naive-bayes',
  'easy',
  'Implement Naive Bayes classifier for text classification and spam detection.

**Bayes'' Theorem:**
P(C|X) = P(X|C) × P(C) / P(X)

Where:
- P(C|X) = Probability of class C given features X (posterior)
- P(X|C) = Probability of features X given class C (likelihood)
- P(C) = Probability of class C (prior)
- P(X) = Probability of features X (evidence)

**Naive Assumption:**
Features are independent given the class:
P(X|C) = P(x₁|C) × P(x₂|C) × ... × P(xₙ|C)

**For Text Classification:**
1. Calculate prior: P(C) = count(C) / total_documents
2. Calculate likelihood: P(word|C) = count(word in C) / count(all words in C)
3. Apply Laplace smoothing to avoid zero probabilities
4. Use log probabilities to avoid underflow

**Algorithm:**
1. Training: Count word frequencies per class
2. Prediction: Calculate P(C|document) for each class
3. Return class with highest probability',
  '[{"input":"Email: \"Buy cheap meds now!\" → classify as spam/ham","output":"spam (words like \"buy\", \"cheap\" more common in spam)","explanation":"Naive Bayes calculates probability based on word frequencies"}]'::jsonb,
  '["Handle text preprocessing (lowercase, remove punctuation)","Implement Laplace smoothing (add-1 smoothing)","Use log probabilities to prevent underflow","Support multinomial and Bernoulli variants"]'::jsonb,
  '["AI/ML","Machine Learning","Classification","NLP"]'::jsonb,
  'AI/ML',
  '{"javascript":"class NaiveBayes {\n  constructor(alpha = 1.0) {\n    this.alpha = alpha; // Laplace smoothing\n    this.classCounts = {};\n    this.wordCounts = {};\n    this.vocab = new Set();\n  }\n  \n  fit(documents, labels) {\n    // Training phase\n    // Count word frequencies per class\n    for (let i = 0; i < documents.length; i++) {\n      const doc = documents[i];\n      const label = labels[i];\n      \n      if (!this.classCounts[label]) {\n        this.classCounts[label] = 0;\n        this.wordCounts[label] = {};\n      }\n      \n      this.classCounts[label]++;\n      \n      const words = this.tokenize(doc);\n      for (const word of words) {\n        this.vocab.add(word);\n        this.wordCounts[label][word] = \n          (this.wordCounts[label][word] || 0) + 1;\n      }\n    }\n  }\n  \n  predict(document) {\n    // Calculate P(C|document) for each class\n    const words = this.tokenize(document);\n    let bestClass = null;\n    let bestProb = -Infinity;\n    \n    for (const cls in this.classCounts) {\n      let logProb = Math.log(this.classCounts[cls] / \n        Object.values(this.classCounts).reduce((a,b) => a+b));\n      \n      // Add log P(word|class) for each word\n      for (const word of words) {\n        const wordCount = this.wordCounts[cls][word] || 0;\n        const totalWords = Object.values(this.wordCounts[cls])\n          .reduce((a,b) => a+b, 0);\n        \n        // Laplace smoothing\n        logProb += Math.log((wordCount + this.alpha) / \n          (totalWords + this.alpha * this.vocab.size));\n      }\n      \n      if (logProb > bestProb) {\n        bestProb = logProb;\n        bestClass = cls;\n      }\n    }\n    \n    return bestClass;\n  }\n  \n  tokenize(text) {\n    return text.toLowerCase()\n      .replace(/[^a-z\\s]/g, '''')\n      .split(/\\s+/)\n      .filter(w => w.length > 0);\n  }\n}","python":"import numpy as np\nfrom collections import defaultdict\nimport re\n\nclass NaiveBayes:\n    def __init__(self, alpha=1.0):\n        self.alpha = alpha  # Laplace smoothing\n        self.class_counts = defaultdict(int)\n        self.word_counts = defaultdict(lambda: defaultdict(int))\n        self.vocab = set()\n    \n    def fit(self, documents, labels):\n        # Training phase\n        for doc, label in zip(documents, labels):\n            self.class_counts[label] += 1\n            \n            words = self.tokenize(doc)\n            for word in words:\n                self.vocab.add(word)\n                self.word_counts[label][word] += 1\n    \n    def predict(self, document):\n        words = self.tokenize(document)\n        best_class = None\n        best_log_prob = float(''-inf'')\n        \n        total_docs = sum(self.class_counts.values())\n        \n        for cls in self.class_counts:\n            # Prior: P(C)\n            log_prob = np.log(self.class_counts[cls] / total_docs)\n            \n            # Likelihood: P(words|C)\n            total_words = sum(self.word_counts[cls].values())\n            \n            for word in words:\n                word_count = self.word_counts[cls][word]\n                # Laplace smoothing\n                log_prob += np.log(\n                    (word_count + self.alpha) / \n                    (total_words + self.alpha * len(self.vocab))\n                )\n            \n            if log_prob > best_log_prob:\n                best_log_prob = log_prob\n                best_class = cls\n        \n        return best_class\n    \n    def tokenize(self, text):\n        text = text.lower()\n        text = re.sub(r''[^a-z\\s]'', '''', text)\n        return [w for w in text.split() if w]\n    \n    def predict_proba(self, document):\n        # Return probability distribution over classes\n        pass","java":"import java.util.*;\n\nclass NaiveBayes {\n    private double alpha;\n    private Map<String, Integer> classCounts;\n    private Map<String, Map<String, Integer>> wordCounts;\n    private Set<String> vocab;\n    \n    public NaiveBayes(double alpha) {\n        this.alpha = alpha;\n        this.classCounts = new HashMap<>();\n        this.wordCounts = new HashMap<>();\n        this.vocab = new HashSet<>();\n    }\n    \n    public void fit(List<String> documents, List<String> labels) {\n        for (int i = 0; i < documents.size(); i++) {\n            String doc = documents.get(i);\n            String label = labels.get(i);\n            \n            classCounts.put(label, classCounts.getOrDefault(label, 0) + 1);\n            \n            if (!wordCounts.containsKey(label)) {\n                wordCounts.put(label, new HashMap<>());\n            }\n            \n            String[] words = tokenize(doc);\n            for (String word : words) {\n                vocab.add(word);\n                Map<String, Integer> counts = wordCounts.get(label);\n                counts.put(word, counts.getOrDefault(word, 0) + 1);\n            }\n        }\n    }\n    \n    public String predict(String document) {\n        String[] words = tokenize(document);\n        String bestClass = null;\n        double bestLogProb = Double.NEGATIVE_INFINITY;\n        \n        int totalDocs = classCounts.values().stream()\n            .mapToInt(Integer::intValue).sum();\n        \n        for (String cls : classCounts.keySet()) {\n            double logProb = Math.log((double) classCounts.get(cls) / totalDocs);\n            \n            int totalWords = wordCounts.get(cls).values().stream()\n                .mapToInt(Integer::intValue).sum();\n            \n            for (String word : words) {\n                int wordCount = wordCounts.get(cls).getOrDefault(word, 0);\n                logProb += Math.log(\n                    (wordCount + alpha) / (totalWords + alpha * vocab.size())\n                );\n            }\n            \n            if (logProb > bestLogProb) {\n                bestLogProb = logProb;\n                bestClass = cls;\n            }\n        }\n        \n        return bestClass;\n    }\n    \n    private String[] tokenize(String text) {\n        return text.toLowerCase()\n            .replaceAll(\"[^a-z\\\\s]\", \"\")\n            .split(\"\\\\s+\");\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Laplace smoothing prevents zero probabilities: add α to numerator, α×|V| to denominator","Use log probabilities: log(a×b) = log(a) + log(b)","Remove stop words (the, is, are) for better accuracy","Feature selection: use TF-IDF or chi-square for important words","Multinomial NB: counts word frequencies","Bernoulli NB: binary (word present or absent)","Works well with high-dimensional sparse data (text)"]'::jsonb,
  0,
  '["Google","Amazon","Spam filter companies"]'::jsonb,
  30,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'knn',
  'K-Nearest Neighbors',
  'knn',
  'easy',
  'Implement K-Nearest Neighbors (KNN) algorithm for classification and regression.

**Algorithm:**
1. Store all training examples
2. For a new point, calculate distance to all training points
3. Find K nearest neighbors
4. **Classification:** Return majority class among K neighbors
5. **Regression:** Return average value of K neighbors

**Distance Metrics:**

**Euclidean Distance:**
d(p,q) = √Σ(pᵢ - qᵢ)²

**Manhattan Distance:**
d(p,q) = Σ|pᵢ - qᵢ|

**Minkowski Distance (generalized):**
d(p,q) = (Σ|pᵢ - qᵢ|ᵖ)^(1/p)

**Choosing K:**
- Small K: More sensitive to noise
- Large K: Smoother boundaries
- Odd K for binary classification (avoid ties)
- Use cross-validation to find optimal K

**Pros:** Simple, no training phase, works with any distance metric
**Cons:** Slow prediction, sensitive to scale, curse of dimensionality',
  '[{"input":"K=3, new point=(5,5), neighbors at (4,4,class A), (6,6,class A), (5,7,class B)","output":"Predict class A (2 out of 3 neighbors)","explanation":"Majority voting among K nearest neighbors"}]'::jsonb,
  '["Support both classification and regression","Implement multiple distance metrics","Handle feature scaling (important for KNN)","Optimize with KD-tree or Ball tree for large datasets"]'::jsonb,
  '["AI/ML","Machine Learning","Classification","Instance-Based"]'::jsonb,
  'AI/ML',
  '{"javascript":"class KNN {\n  constructor(k = 3, distanceMetric = ''euclidean'') {\n    this.k = k;\n    this.distanceMetric = distanceMetric;\n    this.X_train = null;\n    this.y_train = null;\n  }\n  \n  fit(X, y) {\n    this.X_train = X;\n    this.y_train = y;\n  }\n  \n  distance(p1, p2) {\n    if (this.distanceMetric === ''euclidean'') {\n      return Math.sqrt(\n        p1.reduce((sum, val, i) => sum + (val - p2[i]) ** 2, 0)\n      );\n    } else if (this.distanceMetric === ''manhattan'') {\n      return p1.reduce((sum, val, i) => sum + Math.abs(val - p2[i]), 0);\n    }\n  }\n  \n  predict(X) {\n    return X.map(x => {\n      // Calculate distances to all training points\n      const distances = this.X_train.map((train_x, i) => ({\n        distance: this.distance(x, train_x),\n        label: this.y_train[i]\n      }));\n      \n      // Sort by distance and take K nearest\n      distances.sort((a, b) => a.distance - b.distance);\n      const kNearest = distances.slice(0, this.k);\n      \n      // Majority vote for classification\n      const votes = {};\n      for (const neighbor of kNearest) {\n        votes[neighbor.label] = (votes[neighbor.label] || 0) + 1;\n      }\n      \n      return Object.entries(votes)\n        .reduce((a, b) => a[1] > b[1] ? a : b)[0];\n    });\n  }\n  \n  predictRegression(X) {\n    return X.map(x => {\n      const distances = this.X_train.map((train_x, i) => ({\n        distance: this.distance(x, train_x),\n        value: this.y_train[i]\n      }));\n      \n      distances.sort((a, b) => a.distance - b.distance);\n      const kNearest = distances.slice(0, this.k);\n      \n      // Average for regression\n      return kNearest.reduce((sum, n) => sum + n.value, 0) / this.k;\n    });\n  }\n}","python":"import numpy as np\nfrom collections import Counter\n\nclass KNN:\n    def __init__(self, k=3, distance_metric=''euclidean''):\n        self.k = k\n        self.distance_metric = distance_metric\n        self.X_train = None\n        self.y_train = None\n    \n    def fit(self, X, y):\n        self.X_train = np.array(X)\n        self.y_train = np.array(y)\n    \n    def distance(self, p1, p2):\n        if self.distance_metric == ''euclidean'':\n            return np.sqrt(np.sum((p1 - p2) ** 2))\n        elif self.distance_metric == ''manhattan'':\n            return np.sum(np.abs(p1 - p2))\n    \n    def predict(self, X):\n        X = np.array(X)\n        predictions = []\n        \n        for x in X:\n            # Calculate distances to all training points\n            distances = [self.distance(x, x_train) \n                        for x_train in self.X_train]\n            \n            # Get indices of K nearest neighbors\n            k_indices = np.argsort(distances)[:self.k]\n            \n            # Get labels of K nearest neighbors\n            k_nearest_labels = self.y_train[k_indices]\n            \n            # Majority vote\n            most_common = Counter(k_nearest_labels).most_common(1)\n            predictions.append(most_common[0][0])\n        \n        return np.array(predictions)\n    \n    def predict_regression(self, X):\n        X = np.array(X)\n        predictions = []\n        \n        for x in X:\n            distances = [self.distance(x, x_train) \n                        for x_train in self.X_train]\n            k_indices = np.argsort(distances)[:self.k]\n            k_nearest_values = self.y_train[k_indices]\n            \n            # Average for regression\n            predictions.append(np.mean(k_nearest_values))\n        \n        return np.array(predictions)","java":"import java.util.*;\n\nclass KNN {\n    private int k;\n    private String distanceMetric;\n    private double[][] X_train;\n    private int[] y_train;\n    \n    public KNN(int k, String distanceMetric) {\n        this.k = k;\n        this.distanceMetric = distanceMetric;\n    }\n    \n    public void fit(double[][] X, int[] y) {\n        this.X_train = X;\n        this.y_train = y;\n    }\n    \n    private double distance(double[] p1, double[] p2) {\n        if (distanceMetric.equals(\"euclidean\")) {\n            double sum = 0;\n            for (int i = 0; i < p1.length; i++) {\n                sum += Math.pow(p1[i] - p2[i], 2);\n            }\n            return Math.sqrt(sum);\n        } else if (distanceMetric.equals(\"manhattan\")) {\n            double sum = 0;\n            for (int i = 0; i < p1.length; i++) {\n                sum += Math.abs(p1[i] - p2[i]);\n            }\n            return sum;\n        }\n        return 0;\n    }\n    \n    public int[] predict(double[][] X) {\n        int[] predictions = new int[X.length];\n        \n        for (int i = 0; i < X.length; i++) {\n            double[] x = X[i];\n            \n            // Calculate distances\n            List<Neighbor> neighbors = new ArrayList<>();\n            for (int j = 0; j < X_train.length; j++) {\n                double dist = distance(x, X_train[j]);\n                neighbors.add(new Neighbor(dist, y_train[j]));\n            }\n            \n            // Sort by distance\n            Collections.sort(neighbors);\n            \n            // Get K nearest\n            Map<Integer, Integer> votes = new HashMap<>();\n            for (int j = 0; j < k; j++) {\n                int label = neighbors.get(j).label;\n                votes.put(label, votes.getOrDefault(label, 0) + 1);\n            }\n            \n            // Majority vote\n            predictions[i] = votes.entrySet().stream()\n                .max(Map.Entry.comparingByValue())\n                .get().getKey();\n        }\n        \n        return predictions;\n    }\n    \n    class Neighbor implements Comparable<Neighbor> {\n        double distance;\n        int label;\n        \n        public Neighbor(double distance, int label) {\n            this.distance = distance;\n            this.label = label;\n        }\n        \n        public int compareTo(Neighbor other) {\n            return Double.compare(this.distance, other.distance);\n        }\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Feature scaling is critical: use StandardScaler or MinMaxScaler","For large datasets, use KD-tree or Ball tree for faster nearest neighbor search","Weighted KNN: weight by inverse distance (closer neighbors have more influence)","Cross-validation to find optimal K (typically √n)","Curse of dimensionality: KNN degrades with high dimensions","Remove outliers from training data for better results","For imbalanced classes, consider weighted voting"]'::jsonb,
  0,
  '["Google","Amazon","Netflix"]'::jsonb,
  30,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'rnn',
  'Recurrent Neural Networks',
  'rnn',
  'hard',
  'Implement a basic Recurrent Neural Network (RNN) for sequence modeling.

**RNN Architecture:**
RNNs process sequential data by maintaining a hidden state that captures information from previous time steps.

**Forward Pass (at time t):**
hₜ = tanh(Wₕ·hₜ₋₁ + Wₓ·xₜ + bₕ)
yₜ = Wᵧ·hₜ + bᵧ

Where:
- hₜ = hidden state at time t
- xₜ = input at time t
- yₜ = output at time t
- Wₕ, Wₓ, Wᵧ = weight matrices
- bₕ, bᵧ = bias vectors

**Backpropagation Through Time (BPTT):**
1. Forward pass through entire sequence
2. Calculate loss at each time step
3. Backpropagate through time (reverse order)
4. Accumulate gradients
5. Update weights

**Challenges:**
- **Vanishing Gradients:** Gradients become very small for long sequences
- **Exploding Gradients:** Gradients become very large
- Solutions: LSTM/GRU, gradient clipping, proper initialization

**Applications:**
- Language modeling
- Time series prediction
- Machine translation
- Sentiment analysis',
  '[{"input":"Sequence: \"hello\" → predict next character","output":"Train on: h→e, he→l, hel→l, hell→o","explanation":"RNN learns patterns in sequential data"}]'::jsonb,
  '["Implement forward and backward pass","Handle sequences of variable length","Implement gradient clipping","Support many-to-one, one-to-many, many-to-many"]'::jsonb,
  '["AI/ML","Deep Learning","RNN","Sequence Modeling"]'::jsonb,
  'AI/ML',
  '{"javascript":"class RNN {\n  constructor(inputSize, hiddenSize, outputSize) {\n    this.inputSize = inputSize;\n    this.hiddenSize = hiddenSize;\n    this.outputSize = outputSize;\n    \n    // Initialize weights\n    this.Wxh = this.randomMatrix(hiddenSize, inputSize);\n    this.Whh = this.randomMatrix(hiddenSize, hiddenSize);\n    this.Why = this.randomMatrix(outputSize, hiddenSize);\n    \n    this.bh = new Array(hiddenSize).fill(0);\n    this.by = new Array(outputSize).fill(0);\n  }\n  \n  forward(inputs) {\n    const T = inputs.length;\n    const hiddenStates = [new Array(this.hiddenSize).fill(0)];\n    const outputs = [];\n    \n    for (let t = 0; t < T; t++) {\n      const x = inputs[t];\n      const hPrev = hiddenStates[t];\n      \n      // h_t = tanh(Wxh @ x + Whh @ h_prev + bh)\n      const h = this.tanh(\n        this.add(\n          this.matMul(this.Wxh, x),\n          this.matMul(this.Whh, hPrev),\n          this.bh\n        )\n      );\n      \n      hiddenStates.push(h);\n      \n      // y_t = Why @ h + by\n      const y = this.add(this.matMul(this.Why, h), this.by);\n      outputs.push(y);\n    }\n    \n    return { outputs, hiddenStates };\n  }\n  \n  backward(inputs, targets, hiddenStates, learningRate) {\n    // Backpropagation Through Time (BPTT)\n    const T = inputs.length;\n    \n    // Initialize gradients\n    const dWxh = this.zerosLike(this.Wxh);\n    const dWhh = this.zerosLike(this.Whh);\n    const dWhy = this.zerosLike(this.Why);\n    const dbh = new Array(this.hiddenSize).fill(0);\n    const dby = new Array(this.outputSize).fill(0);\n    \n    let dh_next = new Array(this.hiddenSize).fill(0);\n    \n    // Backward pass\n    for (let t = T - 1; t >= 0; t--) {\n      // Compute gradients\n      // ...\n    }\n    \n    // Gradient clipping\n    this.clipGradients([dWxh, dWhh, dWhy], maxNorm=5);\n    \n    // Update weights\n    this.Wxh = this.subtract(this.Wxh, this.scale(dWxh, learningRate));\n    this.Whh = this.subtract(this.Whh, this.scale(dWhh, learningRate));\n    this.Why = this.subtract(this.Why, this.scale(dWhy, learningRate));\n  }\n  \n  tanh(x) {\n    return x.map(val => Math.tanh(val));\n  }\n}","python":"import numpy as np\n\nclass RNN:\n    def __init__(self, input_size, hidden_size, output_size):\n        self.input_size = input_size\n        self.hidden_size = hidden_size\n        self.output_size = output_size\n        \n        # Initialize weights (Xavier initialization)\n        self.Wxh = np.random.randn(hidden_size, input_size) * 0.01\n        self.Whh = np.random.randn(hidden_size, hidden_size) * 0.01\n        self.Why = np.random.randn(output_size, hidden_size) * 0.01\n        \n        self.bh = np.zeros((hidden_size, 1))\n        self.by = np.zeros((output_size, 1))\n    \n    def forward(self, inputs):\n        \"\"\"\n        inputs: list of input vectors, each of shape (input_size, 1)\n        returns: outputs and hidden states\n        \"\"\"\n        T = len(inputs)\n        hidden_states = [np.zeros((self.hidden_size, 1))]\n        outputs = []\n        \n        for t in range(T):\n            x = inputs[t]\n            h_prev = hidden_states[-1]\n            \n            # h_t = tanh(Wxh @ x + Whh @ h_prev + bh)\n            h = np.tanh(self.Wxh @ x + self.Whh @ h_prev + self.bh)\n            hidden_states.append(h)\n            \n            # y_t = Why @ h + by\n            y = self.Why @ h + self.by\n            outputs.append(y)\n        \n        return outputs, hidden_states\n    \n    def backward(self, inputs, targets, hidden_states, learning_rate=0.001):\n        \"\"\"\n        Backpropagation Through Time (BPTT)\n        \"\"\"\n        T = len(inputs)\n        \n        # Initialize gradients\n        dWxh = np.zeros_like(self.Wxh)\n        dWhh = np.zeros_like(self.Whh)\n        dWhy = np.zeros_like(self.Why)\n        dbh = np.zeros_like(self.bh)\n        dby = np.zeros_like(self.by)\n        \n        dh_next = np.zeros((self.hidden_size, 1))\n        \n        # Backward pass\n        for t in reversed(range(T)):\n            x = inputs[t]\n            h = hidden_states[t + 1]\n            h_prev = hidden_states[t]\n            y = self.Why @ h + self.by\n            \n            # Gradient of loss w.r.t output\n            dy = y - targets[t]\n            \n            # Output layer gradients\n            dWhy += dy @ h.T\n            dby += dy\n            \n            # Hidden layer gradients\n            dh = self.Why.T @ dy + dh_next\n            dhraw = (1 - h * h) * dh  # tanh derivative\n            \n            dbh += dhraw\n            dWxh += dhraw @ x.T\n            dWhh += dhraw @ h_prev.T\n            \n            dh_next = self.Whh.T @ dhraw\n        \n        # Clip gradients to prevent exploding gradients\n        for dparam in [dWxh, dWhh, dWhy, dbh, dby]:\n            np.clip(dparam, -5, 5, out=dparam)\n        \n        # Update weights\n        self.Wxh -= learning_rate * dWxh\n        self.Whh -= learning_rate * dWhh\n        self.Why -= learning_rate * dWhy\n        self.bh -= learning_rate * dbh\n        self.by -= learning_rate * dby\n    \n    def sample(self, h, seed_ix, n):\n        \"\"\"\n        Generate sequence by sampling from the model\n        \"\"\"\n        x = np.zeros((self.input_size, 1))\n        x[seed_ix] = 1\n        \n        ixes = []\n        for t in range(n):\n            h = np.tanh(self.Wxh @ x + self.Whh @ h + self.bh)\n            y = self.Why @ h + self.by\n            p = np.exp(y) / np.sum(np.exp(y))  # softmax\n            ix = np.random.choice(range(self.output_size), p=p.ravel())\n            \n            x = np.zeros((self.input_size, 1))\n            x[ix] = 1\n            ixes.append(ix)\n        \n        return ixes","java":"class RNN {\n    private double[][] Wxh, Whh, Why;\n    private double[] bh, by;\n    private int inputSize, hiddenSize, outputSize;\n    \n    public RNN(int inputSize, int hiddenSize, int outputSize) {\n        this.inputSize = inputSize;\n        this.hiddenSize = hiddenSize;\n        this.outputSize = outputSize;\n        \n        // Initialize weights\n        this.Wxh = randomMatrix(hiddenSize, inputSize);\n        this.Whh = randomMatrix(hiddenSize, hiddenSize);\n        this.Why = randomMatrix(outputSize, hiddenSize);\n        \n        this.bh = new double[hiddenSize];\n        this.by = new double[outputSize];\n    }\n    \n    public class ForwardResult {\n        public List<double[]> outputs;\n        public List<double[]> hiddenStates;\n    }\n    \n    public ForwardResult forward(List<double[]> inputs) {\n        int T = inputs.size();\n        List<double[]> hiddenStates = new ArrayList<>();\n        List<double[]> outputs = new ArrayList<>();\n        \n        hiddenStates.add(new double[hiddenSize]); // h_0\n        \n        for (int t = 0; t < T; t++) {\n            double[] x = inputs.get(t);\n            double[] hPrev = hiddenStates.get(t);\n            \n            // h_t = tanh(Wxh @ x + Whh @ h_prev + bh)\n            double[] h = tanh(add(\n                matMul(Wxh, x),\n                matMul(Whh, hPrev),\n                bh\n            ));\n            \n            hiddenStates.add(h);\n            \n            // y_t = Why @ h + by\n            double[] y = add(matMul(Why, h), by);\n            outputs.add(y);\n        }\n        \n        ForwardResult result = new ForwardResult();\n        result.outputs = outputs;\n        result.hiddenStates = hiddenStates;\n        return result;\n    }\n    \n    private double[] tanh(double[] x) {\n        double[] result = new double[x.length];\n        for (int i = 0; i < x.length; i++) {\n            result[i] = Math.tanh(x[i]);\n        }\n        return result;\n    }\n}"}'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '["Truncated BPTT: limit backprop to last k time steps for efficiency","Gradient clipping: clip gradients to [-5, 5] to prevent explosion","Initialize Whh with identity matrix scaled by small value","Use Xavier initialization: weights ~ N(0, 1/√n)","Teacher forcing during training: use true previous output instead of predicted","Vanishing gradient: use LSTM/GRU for long sequences","Batch processing: process multiple sequences in parallel"]'::jsonb,
  0,
  '["Google","DeepMind","OpenAI"]'::jsonb,
  90,
  512
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'array-merger',
  'Array Merger',
  'array-merger',
  'easy',
  'Given two sorted integer arrays nums1 and nums2, merge nums2 into nums1 as one sorted array.

The number of elements initialized in nums1 and nums2 are m and n respectively. You may assume that nums1 has enough space to hold additional elements from nums2.',
  '[{"input":"nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3","output":"[1,2,2,3,5,6]","explanation":"Arrays are merged in sorted order"}]'::jsonb,
  '["nums1.length == m + n","0 <= m, n <= 200"]'::jsonb,
  '["Array","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function merge(nums1, m, nums2, n) {\n  // Your code here\n}","python":"def merge(nums1, m, nums2, n):\n    # Your code here\n    pass","java":"class Solution {\n    public void merge(int[] nums1, int m, int[] nums2, int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,0,0,0], 3, [2,5,6], 3","expectedOutput":"[1,2,2,3,5,6]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Start from the end of both arrays","Use three pointers for tracking positions"]'::jsonb,
  46.2,
  '["Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'palindrome-validator',
  'Palindrome Validator',
  'palindrome-validator',
  'easy',
  'Given a string s, determine if it is a palindrome after removing all non-alphanumeric characters and converting to lowercase.',
  '[{"input":"s = \"A man, a plan, a canal: Panama\"","output":"true"}]'::jsonb,
  '["1 <= s.length <= 2 * 10^5"]'::jsonb,
  '["String","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function isPalindrome(s) {\n  // Your code here\n}","python":"def is_palindrome(s):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean isPalindrome(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"A man, a plan, a canal: Panama\"","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers from start and end","Skip non-alphanumeric characters"]'::jsonb,
  42.1,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'triplet-sum-finder',
  'Triplet Sum Finder',
  'triplet-sum-finder',
  'medium',
  'Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.',
  '[{"input":"nums = [-1,0,1,2,-1,-4]","output":"[[-1,-1,2],[-1,0,1]]"}]'::jsonb,
  '["3 <= nums.length <= 3000","-10^5 <= nums[i] <= 10^5"]'::jsonb,
  '["Array","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function threeSum(nums) {\n  // Your code here\n}","python":"def three_sum(nums):\n    # Your code here\n    pass","java":"class Solution {\n    public List<List<Integer>> threeSum(int[] nums) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-1,0,1,2,-1,-4]","expectedOutput":"[[-1,-1,2],[-1,0,1]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort the array first","Use two pointers for each fixed element"]'::jsonb,
  32.1,
  '["Amazon","Facebook"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'cycle-detector',
  'Cycle Detector',
  'cycle-detector',
  'easy',
  'Given head, the head of a linked list, determine if the linked list has a cycle in it.',
  '[{"input":"head = [3,2,0,-4], pos = 1","output":"true","explanation":"There is a cycle where tail connects to index 1"}]'::jsonb,
  '["The number of nodes in the list is in range [0, 10^4]"]'::jsonb,
  '["Linked List","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function hasCycle(head) {\n  // Your code here\n}","python":"def has_cycle(head):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean hasCycle(ListNode head) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,2,0,-4], pos=1","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use Floyd''s cycle detection algorithm","Slow and fast pointers"]'::jsonb,
  48.3,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'happy-number-detector',
  'Happy Number Detector',
  'happy-number-detector',
  'easy',
  'Write an algorithm to determine if a number n is happy. A happy number is defined by the following process: Starting with any positive integer, replace the number by the sum of the squares of its digits. Repeat until the number equals 1, or it loops endlessly in a cycle.',
  '[{"input":"n = 19","output":"true","explanation":"1^2 + 9^2 = 82, 8^2 + 2^2 = 68, ... eventually reaches 1"}]'::jsonb,
  '["1 <= n <= 2^31 - 1"]'::jsonb,
  '["Hash Table","Math"]'::jsonb,
  'DSA',
  '{"javascript":"function isHappy(n) {\n  // Your code here\n}","python":"def is_happy(n):\n    # Your code here\n    pass","java":"class Solution {\n    public boolean isHappy(int n) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"19","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use slow and fast pointers to detect cycle","Calculate sum of squares of digits"]'::jsonb,
  54.7,
  '["Amazon","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'unique-char-substring',
  'Unique Char Substring',
  'unique-char-substring',
  'medium',
  'Given a string s, find the length of the longest substring without repeating characters.',
  '[{"input":"s = \"abcabcbb\"","output":"3","explanation":"The answer is \"abc\", with length 3"}]'::jsonb,
  '["0 <= s.length <= 5 * 10^4","s consists of English letters, digits, symbols and spaces"]'::jsonb,
  '["String","Sliding Window"]'::jsonb,
  'DSA',
  '{"javascript":"function lengthOfLongestSubstring(s) {\n  // Your code here\n}","python":"def length_of_longest_substring(s):\n    # Your code here\n    pass","java":"class Solution {\n    public int lengthOfLongestSubstring(String s) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abcabcbb\"","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use sliding window with hash set","Track characters in current window"]'::jsonb,
  33.8,
  '["Amazon","Bloomberg"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'interval-merger',
  'Interval Merger',
  'interval-merger',
  'medium',
  'Given an array of intervals where intervals[i] = [start_i, end_i], merge all overlapping intervals.',
  '[{"input":"intervals = [[1,3],[2,6],[8,10],[15,18]]","output":"[[1,6],[8,10],[15,18]]","explanation":"Intervals [1,3] and [2,6] overlap, so merge them"}]'::jsonb,
  '["1 <= intervals.length <= 10^4"]'::jsonb,
  '["Array","Intervals"]'::jsonb,
  'DSA',
  '{"javascript":"function merge(intervals) {\n  // Your code here\n}","python":"def merge(intervals):\n    # Your code here\n    pass","java":"class Solution {\n    public int[][] merge(int[][] intervals) {\n        // Your code here\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,3],[2,6],[8,10],[15,18]]","expectedOutput":"[[1,6],[8,10],[15,18]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort intervals by start time","Merge overlapping intervals as you iterate"]'::jsonb,
  46.3,
  '["Facebook","Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-nth-node-from-end',
  'Remove Nth Node From End of List',
  'remove-nth-node-from-end',
  'medium',
  'Given the head of a linked list, remove the nth node from the end of the list and return its head.',
  '[{"input":"head = [1,2,3,4,5], n = 2","output":"[1,2,3,5]"}]'::jsonb,
  '["The number of nodes in the list is sz","1 <= sz <= 30"]'::jsonb,
  '["Linked List","Two Pointers"]'::jsonb,
  'DSA',
  '{"javascript":"function removeNthFromEnd(head, n) {\n  // Your code here\n}","python":"def remove_nth_from_end(head, n):\n    pass","java":"class Solution {\n    public ListNode removeNthFromEnd(ListNode head, int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5], 2","expectedOutput":"[1,2,3,5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers with n gap","Move both until first reaches end"]'::jsonb,
  42.3,
  '["Facebook","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-words-in-string',
  'Reverse Words in a String',
  'reverse-words-in-string',
  'medium',
  'Given an input string s, reverse the order of the words. A word is defined as a sequence of non-space characters. The words in s will be separated by at least one space.',
  '[{"input":"s = \"the sky is blue\"","output":"\"blue is sky the\""}]'::jsonb,
  '["1 <= s.length <= 10^4"]'::jsonb,
  '["Two Pointers","String"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseWords(s) {\n  // Your code here\n}","python":"def reverse_words(s):\n    pass","java":"class Solution {\n    public String reverseWords(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"the sky is blue\"","expectedOutput":"\"blue is sky the\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Split by spaces","Reverse the word array"]'::jsonb,
  34.2,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'squares-sorted-array',
  'Squares of a Sorted Array',
  'squares-sorted-array',
  'easy',
  'Given an integer array nums sorted in non-decreasing order, return an array of the squares of each number sorted in non-decreasing order.',
  '[{"input":"nums = [-4,-1,0,3,10]","output":"[0,1,9,16,100]"}]'::jsonb,
  '["1 <= nums.length <= 10^4"]'::jsonb,
  '["Array","Two Pointers","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function sortedSquares(nums) {\n  // Your code here\n}","python":"def sorted_squares(nums):\n    pass","java":"class Solution {\n    public int[] sortedSquares(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-4,-1,0,3,10]","expectedOutput":"[0,1,9,16,100]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers from both ends","Compare absolute values"]'::jsonb,
  72.1,
  '["Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-string',
  'Reverse String',
  'reverse-string',
  'easy',
  'Write a function that reverses a string. The input string is given as an array of characters s. You must do this by modifying the input array in-place with O(1) extra memory.',
  '[{"input":"s = [\"h\",\"e\",\"l\",\"l\",\"o\"]","output":"[\"o\",\"l\",\"l\",\"e\",\"h\"]"}]'::jsonb,
  '["1 <= s.length <= 10^5"]'::jsonb,
  '["Two Pointers","String"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseString(s) {\n  // Your code here\n}","python":"def reverse_string(s):\n    pass","java":"class Solution {\n    public void reverseString(char[] s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"h\",\"e\",\"l\",\"l\",\"o\"]","expectedOutput":"[\"o\",\"l\",\"l\",\"e\",\"h\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers","Swap from both ends"]'::jsonb,
  77.4,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'valid-palindrome-ii',
  'Valid Palindrome II',
  'valid-palindrome-ii',
  'easy',
  'Given a string s, return true if the s can be palindrome after deleting at most one character from it.',
  '[{"input":"s = \"aba\"","output":"true"},{"input":"s = \"abca\"","output":"true"}]'::jsonb,
  '["1 <= s.length <= 10^5"]'::jsonb,
  '["Two Pointers","String","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function validPalindrome(s) {\n  // Your code here\n}","python":"def valid_palindrome(s):\n    pass","java":"class Solution {\n    public boolean validPalindrome(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"aba\"","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers","When mismatch, try skipping either character"]'::jsonb,
  39.8,
  '["Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'two-sum-ii',
  'Two Sum II - Input Array Is Sorted',
  'two-sum-ii',
  'medium',
  'Given a 1-indexed array of integers numbers that is already sorted in non-decreasing order, find two numbers such that they add up to a specific target number.',
  '[{"input":"numbers = [2,7,11,15], target = 9","output":"[1,2]"}]'::jsonb,
  '["2 <= numbers.length <= 3 * 10^4"]'::jsonb,
  '["Array","Two Pointers","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function twoSum(numbers, target) {\n  // Your code here\n}","python":"def two_sum(numbers, target):\n    pass","java":"class Solution {\n    public int[] twoSum(int[] numbers, int target) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,7,11,15], 9","expectedOutput":"[1,2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two pointers from both ends","Move pointers based on sum"]'::jsonb,
  59.3,
  '["Amazon","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  '3sum-smaller',
  '3Sum Smaller',
  '3sum-smaller',
  'medium',
  'Given an array of n integers nums and an integer target, find the number of index triplets i, j, k with 0 <= i < j < k < n that satisfy the condition nums[i] + nums[j] + nums[k] < target.',
  '[{"input":"nums = [-2,0,1,3], target = 2","output":"2"}]'::jsonb,
  '["n == nums.length","0 <= n <= 3500"]'::jsonb,
  '["Array","Two Pointers","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function threeSumSmaller(nums, target) {\n  // Your code here\n}","python":"def three_sum_smaller(nums, target):\n    pass","java":"class Solution {\n    public int threeSumSmaller(int[] nums, int target) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-2,0,1,3], 2","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort array first","Fix one element and use two pointers"]'::jsonb,
  51.2,
  '["Google","Amazon"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'course-schedule',
  'Course Schedule',
  'course-schedule',
  'medium',
  'There are a total of numCourses courses you have to take, labeled from 0 to numCourses - 1. You are given an array prerequisites where prerequisites[i] = [ai, bi] indicates that you must take course bi first if you want to take course ai. Return true if you can finish all courses. Otherwise, return false.',
  '[{"input":"numCourses = 2, prerequisites = [[1,0]]","output":"true"},{"input":"numCourses = 2, prerequisites = [[1,0],[0,1]]","output":"false"}]'::jsonb,
  '["1 <= numCourses <= 2000"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function canFinish(numCourses, prerequisites) {\n  // Your code here\n}","python":"def can_finish(numCourses, prerequisites):\n    pass","java":"class Solution {\n    public boolean canFinish(int numCourses, int[][] prerequisites) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"2, [[1,0]]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Detect cycle in directed graph","Use DFS or BFS with in-degree"]'::jsonb,
  45.8,
  '["Amazon","Google","Microsoft"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'course-schedule-ii',
  'Course Schedule II',
  'course-schedule-ii',
  'medium',
  'There are a total of numCourses courses you have to take, labeled from 0 to numCourses - 1. You are given an array prerequisites where prerequisites[i] = [ai, bi] indicates that you must take course bi first if you want to take course ai. Return the ordering of courses you should take to finish all courses. If there are many valid answers, return any of them. If it is impossible to finish all courses, return an empty array.',
  '[{"input":"numCourses = 2, prerequisites = [[1,0]]","output":"[0,1]"},{"input":"numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]","output":"[0,2,1,3]"}]'::jsonb,
  '["1 <= numCourses <= 2000"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function findOrder(numCourses, prerequisites) {\n  // Your code here\n}","python":"def find_order(numCourses, prerequisites):\n    pass","java":"class Solution {\n    public int[] findOrder(int numCourses, int[][] prerequisites) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"2, [[1,0]]","expectedOutput":"[0,1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Topological sort using Kahn''s algorithm","Track in-degrees of nodes"]'::jsonb,
  48.2,
  '["Facebook","Amazon","Microsoft"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'alien-dictionary',
  'Alien Dictionary',
  'alien-dictionary',
  'hard',
  'There is a new alien language that uses the English alphabet. However, the order among the letters is unknown to you. You are given a list of strings words from the alien language''s dictionary, where the strings in words are sorted lexicographically by the rules of this new language. Return a string of the unique letters in the new alien language sorted in lexicographically increasing order by the new language''s rules. If there is no solution, return ''''. If there are multiple solutions, return any of them.',
  '[{"input":"words = [\"wrt\",\"wrf\",\"er\",\"ett\",\"rftt\"]","output":"\"wertf\""}]'::jsonb,
  '["1 <= words.length <= 100"]'::jsonb,
  '["Array","String","Depth-First Search","Breadth-First Search","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function alienOrder(words) {\n  // Your code here\n}","python":"def alien_order(words):\n    pass","java":"class Solution {\n    public String alienOrder(String[] words) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"wrt\",\"wrf\",\"er\",\"ett\",\"rftt\"]","expectedOutput":"\"wertf\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build graph from adjacent words","Apply topological sort"]'::jsonb,
  33.6,
  '["Facebook","Google","Amazon"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'verifying-alien-dictionary',
  'Verifying an Alien Dictionary',
  'verifying-alien-dictionary',
  'easy',
  'In an alien language, surprisingly, they also use English lowercase letters, but possibly in a different order. The order of the alphabet is some permutation of lowercase letters. Given a sequence of words written in the alien language, and the order of the alphabet, return true if and only if the given words are sorted lexicographically in this alien language.',
  '[{"input":"words = [\"hello\",\"leetcode\"], order = \"hlabcdefgijkmnopqrstuvwxyz\"","output":"true"}]'::jsonb,
  '["1 <= words.length <= 100"]'::jsonb,
  '["Array","Hash Table","String"]'::jsonb,
  'DSA',
  '{"javascript":"function isAlienSorted(words, order) {\n  // Your code here\n}","python":"def is_alien_sorted(words, order):\n    pass","java":"class Solution {\n    public boolean isAlienSorted(String[] words, String order) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"hello\",\"leetcode\"], \"hlabcdefgijkmnopqrstuvwxyz\"","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Create order map","Compare adjacent words"]'::jsonb,
  53.7,
  '["Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'course-schedule-ii-210',
  'Course Schedule II (210)',
  'course-schedule-ii-210',
  'medium',
  'There are a total of numCourses courses you have to take, labeled from 0 to numCourses - 1. You are given an array prerequisites where prerequisites[i] = [ai, bi] indicates that you must take course bi first if you want to take course ai. Return the ordering of courses you should take to finish all courses.',
  '[{"input":"numCourses = 2, prerequisites = [[1,0]]","output":"[0,1]"}]'::jsonb,
  '["1 <= numCourses <= 2000"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function findOrder(numCourses, prerequisites) {\n  // Your code here\n}","python":"def find_order(numCourses, prerequisites):\n    pass","java":"class Solution {\n    public int[] findOrder(int numCourses, int[][] prerequisites) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"2, [[1,0]]","expectedOutput":"[0,1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use topological sort","Kahn''s algorithm with in-degree"]'::jsonb,
  48.2,
  '["Facebook","Amazon"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'build-matrix-with-conditions',
  'Build a Matrix With Conditions',
  'build-matrix-with-conditions',
  'hard',
  'You are given a positive integer k. You are also given a 2D integer array rowConditions and a 2D integer array colConditions. Return any matrix that satisfies all the conditions. If no answer exists, return an empty matrix.',
  '[{"input":"k = 3, rowConditions = [[1,2],[3,2]], colConditions = [[2,1],[3,2]]","output":"[[3,0,0],[0,0,1],[0,2,0]]"}]'::jsonb,
  '["2 <= k <= 400"]'::jsonb,
  '["Array","Graph","Topological Sort","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function buildMatrix(k, rowConditions, colConditions) {\n  // Your code here\n}","python":"def build_matrix(k, rowConditions, colConditions):\n    pass","java":"class Solution {\n    public int[][] buildMatrix(int k, int[][] rowConditions, int[][] colConditions) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, [[1,2],[3,2]], [[2,1],[3,2]]","expectedOutput":"[[3,0,0],[0,0,1],[0,2,0]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Apply topological sort separately for rows and columns","Check for cycles"]'::jsonb,
  62.4,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-path-different-adjacent',
  'Longest Path With Different Adjacent Characters',
  'longest-path-different-adjacent',
  'hard',
  'You are given a tree (i.e. a connected, undirected graph that has no cycles) rooted at node 0 consisting of n nodes numbered from 0 to n - 1. The tree is represented by a 0-indexed array parent of size n, where parent[i] is the parent of node i. Since node 0 is the root, parent[0] == -1. You are also given a string s of length n, where s[i] is the character assigned to node i. Return the length of the longest path in the tree such that no pair of adjacent nodes on the path have the same character assigned to them.',
  '[{"input":"parent = [-1,0,0,1,1,2], s = \"abacbe\"","output":"3"}]'::jsonb,
  '["n == parent.length == s.length"]'::jsonb,
  '["Array","String","Tree","Depth-First Search","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function longestPath(parent, s) {\n  // Your code here\n}","python":"def longest_path(parent, s):\n    pass","java":"class Solution {\n    public int longestPath(int[] parent, String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-1,0,0,1,1,2], \"abacbe\"","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use DFS from leaves","Track longest paths through each node"]'::jsonb,
  47.8,
  '["Google","Facebook"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'parallel-courses-iii',
  'Parallel Courses III',
  'parallel-courses-iii',
  'hard',
  'You are given an integer n, which indicates that there are n courses labeled from 1 to n. You are also given a 2D integer array relations where relations[j] = [prevCoursej, nextCoursej] denotes that course prevCoursej has to be completed before course nextCoursej. Furthermore, you are given a 0-indexed integer array time where time[i] denotes how many months it takes to complete the (i+1)th course. Return the minimum number of months needed to complete all the courses.',
  '[{"input":"n = 3, relations = [[1,3],[2,3]], time = [3,2,5]","output":"8"}]'::jsonb,
  '["1 <= n <= 5 * 10^4"]'::jsonb,
  '["Array","Dynamic Programming","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumTime(n, relations, time) {\n  // Your code here\n}","python":"def minimum_time(n, relations, time):\n    pass","java":"class Solution {\n    public int minimumTime(int n, int[][] relations, int[] time) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, [[1,3],[2,3]], [3,2,5]","expectedOutput":"8","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use topological sort with DP","Track earliest completion time for each course"]'::jsonb,
  62.8,
  '["Amazon","Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-all-recipes',
  'Find All Possible Recipes from Given Supplies',
  'find-all-recipes',
  'medium',
  'You have information about n different recipes. You are given a string array recipes and a 2D string array ingredients. The ith recipe has the name recipes[i], and you can create it if you have all the needed ingredients from ingredients[i]. Ingredients to a recipe may need to be created from other recipes. You are also given a string array supplies containing all the ingredients that you initially have. Return a list of all the recipes that you can create.',
  '[{"input":"recipes = [\"bread\"], ingredients = [[\"yeast\",\"flour\"]], supplies = [\"yeast\",\"flour\",\"corn\"]","output":"[\"bread\"]"}]'::jsonb,
  '["n == recipes.length == ingredients.length"]'::jsonb,
  '["Array","Hash Table","String","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function findAllRecipes(recipes, ingredients, supplies) {\n  // Your code here\n}","python":"def find_all_recipes(recipes, ingredients, supplies):\n    pass","java":"class Solution {\n    public List<String> findAllRecipes(String[] recipes, List<List<String>> ingredients, String[] supplies) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"bread\"], [[\"yeast\",\"flour\"]], [\"yeast\",\"flour\",\"corn\"]","expectedOutput":"[\"bread\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build dependency graph","Use topological sort to find creatable recipes"]'::jsonb,
  42.3,
  '["Amazon"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'distance-value-two-arrays',
  'Find the Distance Value Between Two Arrays',
  'distance-value-two-arrays',
  'easy',
  'Given two integer arrays arr1 and arr2, and the integer d, return the distance value between the two arrays. The distance value is defined as the number of elements arr1[i] such that there is not any element arr2[j] where |arr1[i]-arr2[j]| <= d.',
  '[{"input":"arr1 = [4,5,8], arr2 = [10,9,1,8], d = 2","output":"2"}]'::jsonb,
  '["1 <= arr1.length, arr2.length <= 500"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function findTheDistanceValue(arr1, arr2, d) {\n  // Your code here\n}","python":"def find_the_distance_value(arr1, arr2, d):\n    pass","java":"class Solution {\n    public int findTheDistanceValue(int[] arr1, int[] arr2, int d) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,5,8], [10,9,1,8], 2","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort arr2 first","Use binary search for efficient lookup"]'::jsonb,
  66.7,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-subsequence-limited-sum',
  'Longest Subsequence With Limited Sum',
  'longest-subsequence-limited-sum',
  'easy',
  'You are given an integer array nums of length n, and an integer array queries of length m. Return an array answer of length m where answer[i] is the maximum size of a subsequence that you can take from nums such that the sum of its elements is less than or equal to queries[i].',
  '[{"input":"nums = [4,5,2,1], queries = [3,10,21]","output":"[2,3,4]"}]'::jsonb,
  '["n == nums.length","m == queries.length"]'::jsonb,
  '["Array","Binary Search","Greedy","Sorting","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function answerQueries(nums, queries) {\n  // Your code here\n}","python":"def answer_queries(nums, queries):\n    pass","java":"class Solution {\n    public int[] answerQueries(int[] nums, int[] queries) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,5,2,1], [3,10,21]","expectedOutput":"[2,3,4]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort nums first","Use prefix sum and binary search"]'::jsonb,
  67.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-target-indices',
  'Find Target Indices After Sorting Array',
  'find-target-indices',
  'easy',
  'You are given a 0-indexed integer array nums and a target element target. A target index is an index i such that nums[i] == target. Return a list of the target indices of nums after sorting nums in non-decreasing order. If there are no target indices, return an empty list.',
  '[{"input":"nums = [1,2,5,2,3], target = 2","output":"[1,2]"}]'::jsonb,
  '["1 <= nums.length <= 100"]'::jsonb,
  '["Array","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function targetIndices(nums, target) {\n  // Your code here\n}","python":"def target_indices(nums, target):\n    pass","java":"class Solution {\n    public List<Integer> targetIndices(int[] nums, int target) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,5,2,3], 2","expectedOutput":"[1,2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort the array","Find all positions of target"]'::jsonb,
  79.3,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'count-pairs-two-arrays',
  'Count Pairs in Two Arrays',
  'count-pairs-two-arrays',
  'hard',
  'Given two integer arrays nums1 and nums2 of length n, count the pairs of indices (i, j) in which i < j and nums1[i] + nums1[j] > nums2[i] + nums2[j].',
  '[{"input":"nums1 = [2,1,2,1], nums2 = [1,2,1,2]","output":"1"}]'::jsonb,
  '["n == nums1.length == nums2.length"]'::jsonb,
  '["Array","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function countPairs(nums1, nums2) {\n  // Your code here\n}","python":"def count_pairs(nums1, nums2):\n    pass","java":"class Solution {\n    public long countPairs(int[] nums1, int[] nums2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,1,2,1], [1,2,1,2]","expectedOutput":"1","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Transform to nums1[i] - nums2[i]","Sort and use two pointers"]'::jsonb,
  48.5,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'valid-triangle-number',
  'Valid Triangle Number',
  'valid-triangle-number',
  'medium',
  'Given an integer array nums, return the number of triplets chosen from the array that can make triangles if we take them as side lengths of a triangle.',
  '[{"input":"nums = [2,2,3,4]","output":"3"}]'::jsonb,
  '["1 <= nums.length <= 1000"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Greedy","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function triangleNumber(nums) {\n  // Your code here\n}","python":"def triangle_number(nums):\n    pass","java":"class Solution {\n    public int triangleNumber(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,2,3,4]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort array first","Fix largest side, use two pointers"]'::jsonb,
  50.8,
  '["Amazon","Facebook"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-operations-equal',
  'Minimum Operations to Make All Array Elements Equal',
  'minimum-operations-equal',
  'medium',
  'You are given an array nums consisting of positive integers. You are also given an integer array queries of size m. For the ith query, you want to make all of the elements of nums equal to queries[i]. Return an array answer of size m where answer[i] is the minimum number of operations to make all elements of nums equal to queries[i].',
  '[{"input":"nums = [3,1,6,8], queries = [1,5]","output":"[14,10]"}]'::jsonb,
  '["n == nums.length","m == queries.length"]'::jsonb,
  '["Array","Binary Search","Prefix Sum","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function minOperations(nums, queries) {\n  // Your code here\n}","python":"def min_operations(nums, queries):\n    pass","java":"class Solution {\n    public List<Long> minOperations(int[] nums, int[] queries) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,1,6,8], [1,5]","expectedOutput":"[14,10]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort nums","Use prefix sum and binary search"]'::jsonb,
  42.7,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sum-mutated-array-target',
  'Sum of Mutated Array Closest to Target',
  'sum-mutated-array-target',
  'medium',
  'Given an integer array arr and a target value target, return the integer value such that when we change all the integers larger than value in the given array to be equal to value, the sum of the array gets as close as possible (absolute difference) to target.',
  '[{"input":"arr = [4,9,3], target = 10","output":"3"}]'::jsonb,
  '["1 <= arr.length <= 10^4"]'::jsonb,
  '["Array","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function findBestValue(arr, target) {\n  // Your code here\n}","python":"def find_best_value(arr, target):\n    pass","java":"class Solution {\n    public int findBestValue(int[] arr, int target) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,9,3], 10","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on the value","Calculate sum after mutation"]'::jsonb,
  44.2,
  '["Amazon"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'range-sum-sorted-subarray',
  'Range Sum of Sorted Subarray Sums',
  'range-sum-sorted-subarray',
  'medium',
  'You are given the array nums consisting of n positive integers. You computed the sum of all non-empty continuous subarrays from the array and then sorted them in non-decreasing order, creating a new array of n * (n + 1) / 2 numbers. Return the sum of the numbers from index left to index right (indexed from 1), inclusive, in the new array.',
  '[{"input":"nums = [1,2,3,4], n = 4, left = 1, right = 5","output":"13"}]'::jsonb,
  '["n == nums.length"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function rangeSum(nums, n, left, right) {\n  // Your code here\n}","python":"def range_sum(nums, n, left, right):\n    pass","java":"class Solution {\n    public int rangeSum(int[] nums, int n, int left, int right) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4], 4, 1, 5","expectedOutput":"13","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Generate all subarray sums","Sort and sum the range"]'::jsonb,
  61.2,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'magnetic-force-two-balls',
  'Magnetic Force Between Two Balls',
  'magnetic-force-two-balls',
  'medium',
  'In the universe Earth C-137, Rick discovered a special form of magnetic force between two balls if they are put in his new invented basket. Rick has n empty baskets, the ith basket is at position[i], Morty has m balls and needs to distribute the balls into the baskets such that the minimum magnetic force between any two balls is maximum. Return the required force.',
  '[{"input":"position = [1,2,3,4,7], m = 3","output":"3"}]'::jsonb,
  '["n == position.length"]'::jsonb,
  '["Array","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function maxDistance(position, m) {\n  // Your code here\n}","python":"def max_distance(position, m):\n    pass","java":"class Solution {\n    public int maxDistance(int[] position, int m) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,7], 3","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort positions","Binary search on the answer"]'::jsonb,
  51.7,
  '["Amazon","Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-kth-smallest-pair',
  'Find K-th Smallest Pair Distance',
  'find-kth-smallest-pair',
  'hard',
  'The distance of a pair of integers a and b is defined as the absolute difference between a and b. Given an integer array nums and an integer k, return the kth smallest distance among all the pairs nums[i] and nums[j] where 0 <= i < j < nums.length.',
  '[{"input":"nums = [1,3,1], k = 1","output":"0"}]'::jsonb,
  '["n == nums.length"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function smallestDistancePair(nums, k) {\n  // Your code here\n}","python":"def smallest_distance_pair(nums, k):\n    pass","java":"class Solution {\n    public int smallestDistancePair(int[] nums, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,3,1], 1","expectedOutput":"0","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort the array","Binary search on distance value"]'::jsonb,
  35.8,
  '["Amazon","Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-space-wasted',
  'Minimum Space Wasted From Packaging',
  'minimum-space-wasted',
  'hard',
  'You have n packages that you are trying to place in boxes, one package in each box. There are m suppliers that each produce boxes of different sizes. Each supplier will provide an unlimited number of boxes of the same size. Return the minimum total wasted space by choosing the box supplier optimally, or -1 if it is impossible to fit all the packages.',
  '[{"input":"packages = [2,3,5], boxes = [[4,8],[2,8]]","output":"6"}]'::jsonb,
  '["n == packages.length"]'::jsonb,
  '["Array","Binary Search","Sorting","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function minWastedSpace(packages, boxes) {\n  // Your code here\n}","python":"def min_wasted_space(packages, boxes):\n    pass","java":"class Solution {\n    public int minWastedSpace(int[] packages, int[][] boxes) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,3,5], [[4,8],[2,8]]","expectedOutput":"6","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort packages and boxes","Use binary search for each supplier"]'::jsonb,
  28.4,
  '["Amazon"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'russian-doll-envelopes',
  'Russian Doll Envelopes',
  'russian-doll-envelopes',
  'hard',
  'You are given a 2D array of integers envelopes where envelopes[i] = [wi, hi] represents the width and the height of an envelope. One envelope can fit into another if and only if both the width and height of one envelope are greater than the other envelope''s width and height. Return the maximum number of envelopes you can Russian doll.',
  '[{"input":"envelopes = [[5,4],[6,4],[6,7],[2,3]]","output":"3"}]'::jsonb,
  '["1 <= envelopes.length <= 10^5"]'::jsonb,
  '["Array","Binary Search","Dynamic Programming","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function maxEnvelopes(envelopes) {\n  // Your code here\n}","python":"def max_envelopes(envelopes):\n    pass","java":"class Solution {\n    public int maxEnvelopes(int[][] envelopes) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[5,4],[6,4],[6,7],[2,3]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort by width, descending height","Find LIS on heights"]'::jsonb,
  38.7,
  '["Facebook","Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'put-marbles-bags',
  'Put Marbles in Bags',
  'put-marbles-bags',
  'hard',
  'You have k bags. You are given a 0-indexed integer array weights where weights[i] is the weight of the ith marble. You are also given the integer k. Divide the marbles into the k bags according to the following rules: No bag is empty. If the ith marble and jth marble are in a bag, then all marbles with an index between the ith and jth indices should also be in that same bag. Return the difference between the maximum and minimum scores among all possible distributions.',
  '[{"input":"weights = [1,3,5,1], k = 2","output":"4"}]'::jsonb,
  '["1 <= k <= weights.length <= 10^5"]'::jsonb,
  '["Array","Greedy","Sorting","Heap (Priority Queue)"]'::jsonb,
  'DSA',
  '{"javascript":"function putMarbles(weights, k) {\n  // Your code here\n}","python":"def put_marbles(weights, k):\n    pass","java":"class Solution {\n    public long putMarbles(int[] weights, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,3,5,1], 2","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Calculate pair sums at split points","Sort and pick k-1 largest/smallest"]'::jsonb,
  67.8,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'h-index',
  'H-Index',
  'h-index',
  'medium',
  'Given an array of integers citations where citations[i] is the number of citations a researcher received for their ith paper, return compute the researcher''s h-index. According to the definition of h-index on Wikipedia: A scientist has an index h if h of their n papers have at least h citations each, and the other n − h papers have no more than h citations each.',
  '[{"input":"citations = [3,0,6,1,5]","output":"3"}]'::jsonb,
  '["n == citations.length"]'::jsonb,
  '["Array","Sorting","Counting Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function hIndex(citations) {\n  // Your code here\n}","python":"def h_index(citations):\n    pass","java":"class Solution {\n    public int hIndex(int[] citations) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,0,6,1,5]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort in descending order","Find where index equals citations"]'::jsonb,
  39.2,
  '["Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'two-sum-less-k',
  'Two Sum Less Than K',
  'two-sum-less-k',
  'easy',
  'Given an array nums of integers and integer k, return the maximum sum such that there exists i < j with nums[i] + nums[j] = sum and sum < k. If no i, j exist satisfying this equation, return -1.',
  '[{"input":"nums = [34,23,1,24,75,33,54,8], k = 60","output":"58"}]'::jsonb,
  '["1 <= nums.length <= 100"]'::jsonb,
  '["Array","Two Pointers","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function twoSumLessThanK(nums, k) {\n  // Your code here\n}","python":"def two_sum_less_than_k(nums, k):\n    pass","java":"class Solution {\n    public int twoSumLessThanK(int[] nums, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[34,23,1,24,75,33,54,8], 60","expectedOutput":"58","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort the array","Use two pointers from both ends"]'::jsonb,
  60.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-integers-range',
  'Maximum Number of Integers to Choose From a Range I',
  'maximum-integers-range',
  'medium',
  'You are given an integer array banned and two integers n and maxSum. You are choosing some number of integers following the below rules: The chosen integers have to be in the range [1, n]. Each integer can be chosen at most once. The chosen integers should not be in the array banned. The sum of the chosen integers should not exceed maxSum. Return the maximum number of integers you can choose following the mentioned rules.',
  '[{"input":"banned = [1,6,5], n = 5, maxSum = 6","output":"2"}]'::jsonb,
  '["1 <= banned.length <= 10^4"]'::jsonb,
  '["Array","Hash Table","Binary Search","Greedy","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function maxCount(banned, n, maxSum) {\n  // Your code here\n}","python":"def max_count(banned, n, maxSum):\n    pass","java":"class Solution {\n    public int maxCount(int[] banned, int n, int maxSum) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,6,5], 5, 6","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use hash set for banned","Greedily pick smallest available numbers"]'::jsonb,
  41.5,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'set-matrix-zeroes',
  'Set Matrix Zeroes',
  'set-matrix-zeroes',
  'medium',
  'Given an m x n integer matrix matrix, if an element is 0, set its entire row and column to 0''s. You must do it in place.',
  '[{"input":"matrix = [[1,1,1],[1,0,1],[1,1,1]]","output":"[[1,0,1],[0,0,0],[1,0,1]]"}]'::jsonb,
  '["m == matrix.length","n == matrix[0].length"]'::jsonb,
  '["Array","Hash Table","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function setZeroes(matrix) {\n  // Your code here\n}","python":"def set_zeroes(matrix):\n    pass","java":"class Solution {\n    public void setZeroes(int[][] matrix) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1,1],[1,0,1],[1,1,1]]","expectedOutput":"[[1,0,1],[0,0,0],[1,0,1]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use first row and column as markers","Process matrix in two passes"]'::jsonb,
  51.2,
  '["Microsoft","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'rotate-image',
  'Rotate Image',
  'rotate-image',
  'medium',
  'You are given an n x n 2D matrix representing an image, rotate the image by 90 degrees (clockwise). You have to rotate the image in-place, which means you have to modify the input 2D matrix directly.',
  '[{"input":"matrix = [[1,2,3],[4,5,6],[7,8,9]]","output":"[[7,4,1],[8,5,2],[9,6,3]]"}]'::jsonb,
  '["n == matrix.length == matrix[i].length"]'::jsonb,
  '["Array","Math","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function rotate(matrix) {\n  // Your code here\n}","python":"def rotate(matrix):\n    pass","java":"class Solution {\n    public void rotate(int[][] matrix) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2,3],[4,5,6],[7,8,9]]","expectedOutput":"[[7,4,1],[8,5,2],[9,6,3]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Transpose then reverse each row","Or rotate layer by layer"]'::jsonb,
  71.3,
  '["Apple","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'spiral-matrix',
  'Spiral Matrix',
  'spiral-matrix',
  'medium',
  'Given an m x n matrix, return all elements of the matrix in spiral order.',
  '[{"input":"matrix = [[1,2,3],[4,5,6],[7,8,9]]","output":"[1,2,3,6,9,8,7,4,5]"}]'::jsonb,
  '["m == matrix.length","n == matrix[i].length"]'::jsonb,
  '["Array","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function spiralOrder(matrix) {\n  // Your code here\n}","python":"def spiral_order(matrix):\n    pass","java":"class Solution {\n    public List<Integer> spiralOrder(int[][] matrix) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2,3],[4,5,6],[7,8,9]]","expectedOutput":"[1,2,3,6,9,8,7,4,5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Track boundaries: top, bottom, left, right","Process layer by layer"]'::jsonb,
  46.8,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'where-will-ball-fall',
  'Where Will the Ball Fall',
  'where-will-ball-fall',
  'medium',
  'You have a 2-D grid of size m x n representing a box, and you have n balls. The box is open on the top and bottom sides. Each cell in the box has a diagonal board spanning two corners of the cell that can redirect a ball to the right or to the left. Return an array answer of size n where answer[i] is the column that the ball falls out of at the bottom after dropping the ball from the ith column at the top, or -1 if the ball gets stuck in the box.',
  '[{"input":"grid = [[1,1,1,-1,-1],[1,1,1,-1,-1],[-1,-1,-1,1,1],[1,1,1,1,-1],[-1,-1,-1,-1,-1]]","output":"[1,-1,-1,-1,-1]"}]'::jsonb,
  '["m == grid.length","n == grid[i].length"]'::jsonb,
  '["Array","Dynamic Programming","Depth-First Search","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function findBall(grid) {\n  // Your code here\n}","python":"def find_ball(grid):\n    pass","java":"class Solution {\n    public int[] findBall(int[][] grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1,1,-1,-1],[1,1,1,-1,-1],[-1,-1,-1,1,1],[1,1,1,1,-1],[-1,-1,-1,-1,-1]]","expectedOutput":"[1,-1,-1,-1,-1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Simulate ball movement","Check for V-shaped traps"]'::jsonb,
  69.2,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'transpose-matrix',
  'Transpose Matrix',
  'transpose-matrix',
  'easy',
  'Given a 2D integer array matrix, return the transpose of matrix. The transpose of a matrix is the matrix flipped over its main diagonal, switching the matrix''s row and column indices.',
  '[{"input":"matrix = [[1,2,3],[4,5,6],[7,8,9]]","output":"[[1,4,7],[2,5,8],[3,6,9]]"}]'::jsonb,
  '["m == matrix.length","n == matrix[i].length"]'::jsonb,
  '["Array","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function transpose(matrix) {\n  // Your code here\n}","python":"def transpose(matrix):\n    pass","java":"class Solution {\n    public int[][] transpose(int[][] matrix) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2,3],[4,5,6],[7,8,9]]","expectedOutput":"[[1,4,7],[2,5,8],[3,6,9]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Create new matrix with swapped dimensions","result[j][i] = matrix[i][j]"]'::jsonb,
  62.4,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'count-negative-numbers-sorted-matrix',
  'Count Negative Numbers in a Sorted Matrix',
  'count-negative-numbers-sorted-matrix',
  'easy',
  'Given a m x n matrix grid which is sorted in non-increasing order both row-wise and column-wise, return the number of negative numbers in grid.',
  '[{"input":"grid = [[4,3,2,-1],[3,2,1,-1],[1,1,-1,-2],[-1,-1,-2,-3]]","output":"8"}]'::jsonb,
  '["m == grid.length","n == grid[i].length"]'::jsonb,
  '["Array","Binary Search","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function countNegatives(grid) {\n  // Your code here\n}","python":"def count_negatives(grid):\n    pass","java":"class Solution {\n    public int countNegatives(int[][] grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[4,3,2,-1],[3,2,1,-1],[1,1,-1,-2],[-1,-1,-2,-3]]","expectedOutput":"8","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Start from bottom-left or top-right","Use binary search on each row"]'::jsonb,
  76.3,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-safest-path-grid',
  'Find the Safest Path in a Grid',
  'find-safest-path-grid',
  'hard',
  'You are given a 0-indexed 2D matrix grid of size n x n, where (r, c) represents a cell containing a thief if grid[r][c] = 1 and an empty cell if grid[r][c] = 0. Return the maximum safeness factor of all paths leading to cell (n - 1, n - 1). The safeness factor of a path is the minimum Manhattan distance from any cell in the path to any thief in the grid.',
  '[{"input":"grid = [[1,0,0],[0,0,0],[0,0,1]]","output":"0"}]'::jsonb,
  '["1 <= grid.length == n <= 400"]'::jsonb,
  '["Array","Binary Search","Breadth-First Search","Union Find","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function maximumSafenessFactor(grid) {\n  // Your code here\n}","python":"def maximum_safeness_factor(grid):\n    pass","java":"class Solution {\n    public int maximumSafenessFactor(List<List<Integer>> grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,0,0],[0,0,0],[0,0,1]]","expectedOutput":"0","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Multi-source BFS for distances","Binary search on safeness factor"]'::jsonb,
  46.2,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'smallest-rectangle-enclosing-black-pixels',
  'Smallest Rectangle Enclosing Black Pixels',
  'smallest-rectangle-enclosing-black-pixels',
  'hard',
  'You are given an m x n binary matrix image where 0 represents a white pixel and 1 represents a black pixel. The black pixels are connected (i.e., there is only one black region). Pixels are connected horizontally and vertically. Given two integers x and y that represent the location of one of the black pixels, return the area of the smallest (axis-aligned) rectangle that encloses all black pixels.',
  '[{"input":"image = [[\"0\",\"0\",\"1\",\"0\"],[\"0\",\"1\",\"1\",\"0\"],[\"0\",\"1\",\"0\",\"0\"]], x = 0, y = 2","output":"6"}]'::jsonb,
  '["m == image.length","n == image[i].length"]'::jsonb,
  '["Array","Binary Search","Depth-First Search","Breadth-First Search","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function minArea(image, x, y) {\n  // Your code here\n}","python":"def min_area(image, x, y):\n    pass","java":"class Solution {\n    public int minArea(char[][] image, int x, int y) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[\"0\",\"0\",\"1\",\"0\"],[\"0\",\"1\",\"1\",\"0\"],[\"0\",\"1\",\"0\",\"0\"]], 0, 2","expectedOutput":"6","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on boundaries","Find min/max row and column with black pixels"]'::jsonb,
  57.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'island-perimeter',
  'Island Perimeter',
  'island-perimeter',
  'easy',
  'You are given row x col grid representing a map where grid[i][j] = 1 represents land and grid[i][j] = 0 represents water. Grid cells are connected horizontally/vertically (not diagonally). The grid is completely surrounded by water, and there is exactly one island. Return the perimeter of the island.',
  '[{"input":"grid = [[0,1,0,0],[1,1,1,0],[0,1,0,0],[1,1,0,0]]","output":"16"}]'::jsonb,
  '["row == grid.length","col == grid[i].length"]'::jsonb,
  '["Array","Depth-First Search","Breadth-First Search","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function islandPerimeter(grid) {\n  // Your code here\n}","python":"def island_perimeter(grid):\n    pass","java":"class Solution {\n    public int islandPerimeter(int[][] grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,1,0,0],[1,1,1,0],[0,1,0,0],[1,1,0,0]]","expectedOutput":"16","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count land cells and adjacent land pairs","perimeter = 4 * lands - 2 * neighbors"]'::jsonb,
  70.3,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'convert-1d-array-into-2d-array',
  'Convert 1D Array Into 2D Array',
  'convert-1d-array-into-2d-array',
  'easy',
  'You are given a 0-indexed 1-dimensional (1D) integer array original, and two integers, m and n. You are tasked with creating a 2-dimensional (2D) array with m rows and n columns using all the elements from original. Return an m x n 2D array constructed according to the above procedure, or an empty 2D array if it is impossible.',
  '[{"input":"original = [1,2,3,4], m = 2, n = 2","output":"[[1,2],[3,4]]"}]'::jsonb,
  '["1 <= original.length <= 5 * 10^4"]'::jsonb,
  '["Array","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function construct2DArray(original, m, n) {\n  // Your code here\n}","python":"def construct_2d_array(original, m, n):\n    pass","java":"class Solution {\n    public int[][] construct2DArray(int[] original, int m, int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4], 2, 2","expectedOutput":"[[1,2],[3,4]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Check if original.length == m * n","Fill matrix row by row"]'::jsonb,
  61.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'spiral-matrix-ii',
  'Spiral Matrix II',
  'spiral-matrix-ii',
  'medium',
  'Given a positive integer n, generate an n x n matrix filled with elements from 1 to n² in spiral order.',
  '[{"input":"n = 3","output":"[[1,2,3],[8,9,4],[7,6,5]]"}]'::jsonb,
  '["1 <= n <= 20"]'::jsonb,
  '["Array","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function generateMatrix(n) {\n  // Your code here\n}","python":"def generate_matrix(n):\n    pass","java":"class Solution {\n    public int[][] generateMatrix(int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3","expectedOutput":"[[1,2,3],[8,9,4],[7,6,5]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use boundary variables","Fill in spiral order: right, down, left, up"]'::jsonb,
  69.7,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'flip-columns-maximum-equal-rows',
  'Flip Columns For Maximum Number of Equal Rows',
  'flip-columns-maximum-equal-rows',
  'medium',
  'You are given an m x n binary matrix matrix. You can choose any number of columns in the matrix and flip every cell in that column (i.e., Change the value of the cell from 0 to 1 or vice versa). Return the maximum number of rows that have all values equal after some number of flips.',
  '[{"input":"matrix = [[0,1],[1,1]]","output":"1"}]'::jsonb,
  '["m == matrix.length","n == matrix[i].length"]'::jsonb,
  '["Array","Hash Table","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function maxEqualRowsAfterFlips(matrix) {\n  // Your code here\n}","python":"def max_equal_rows_after_flips(matrix):\n    pass","java":"class Solution {\n    public int maxEqualRowsAfterFlips(int[][] matrix) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,1],[1,1]]","expectedOutput":"1","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Group rows by pattern","Count original and flipped patterns"]'::jsonb,
  63.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-spaces-cleaning-robot',
  'Number of Spaces Cleaning Robot Cleaned',
  'number-spaces-cleaning-robot',
  'medium',
  'A room is represented by a 0-indexed 2D binary matrix room where a 0 represents an empty space and a 1 represents a space with an object. In one operation, the robot can move to any empty space in any of the four cardinal directions. Return the number of different non-empty spaces the robot visited before getting trapped.',
  '[{"input":"room = [[0,0,0],[0,1,0],[1,1,1]], row = 1, col = 3","output":"1"}]'::jsonb,
  '["m == room.length","n == room[i].length"]'::jsonb,
  '["Array","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function numberOfCleanRooms(room) {\n  // Your code here\n}","python":"def number_of_clean_rooms(room):\n    pass","java":"class Solution {\n    public int numberOfCleanRooms(int[][] room) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,0,0],[0,1,0],[1,1,1]]","expectedOutput":"7","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Simulate robot movement","Track visited states (position + direction)"]'::jsonb,
  42.7,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-operations-make-array-equal-ii',
  'Minimum Operations to Make Array Equal II',
  'minimum-operations-make-array-equal-ii',
  'hard',
  'You are given two integer arrays nums1 and nums2 of equal length n and an integer k. You can perform operations to make nums1 equal to nums2. In one operation, you can add or subtract k from any element of nums1. Return the minimum number of operations required, or return -1 if it is impossible.',
  '[{"input":"nums1 = [4,3,1,4], nums2 = [1,3,7,1], k = 3","output":"2"}]'::jsonb,
  '["n == nums1.length == nums2.length"]'::jsonb,
  '["Array","Math","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function minOperations(nums1, nums2, k) {\n  // Your code here\n}","python":"def min_operations(nums1, nums2, k):\n    pass","java":"class Solution {\n    public long minOperations(int[] nums1, int[] nums2, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,3,1,4], [1,3,7,1], 3","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Check if differences are divisible by k","Balance positive and negative differences"]'::jsonb,
  38.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'kth-smallest-multiplication-table',
  'Kth Smallest Number in Multiplication Table',
  'kth-smallest-multiplication-table',
  'hard',
  'Nearly everyone has used the Multiplication Table. The multiplication table of size m x n is an integer matrix mat where mat[i][j] == i * j (1-indexed). Given three integers m, n, and k, return the kth smallest element in the m x n multiplication table.',
  '[{"input":"m = 3, n = 3, k = 5","output":"3"}]'::jsonb,
  '["1 <= m, n <= 3 * 10^4"]'::jsonb,
  '["Math","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function findKthNumber(m, n, k) {\n  // Your code here\n}","python":"def find_kth_number(m, n, k):\n    pass","java":"class Solution {\n    public int findKthNumber(int m, int n, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, 3, 5","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on the value","Count numbers <= mid in table"]'::jsonb,
  52.4,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'swim-in-rising-water',
  'Swim in Rising Water',
  'swim-in-rising-water',
  'hard',
  'You are given an n x n integer matrix grid where each value grid[i][j] represents the elevation at that point (i, j). The rain starts to fall. At time t, the depth of the water everywhere is t. You can swim from a square to another 4-directionally adjacent square if the elevation of both squares is at most t. Return the least time until you can reach the bottom right square (n - 1, n - 1) if you start at the top left square (0, 0).',
  '[{"input":"grid = [[0,2],[1,3]]","output":"3"}]'::jsonb,
  '["n == grid.length == grid[i].length"]'::jsonb,
  '["Array","Binary Search","Depth-First Search","Breadth-First Search","Union Find","Heap (Priority Queue)","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function swimInWater(grid) {\n  // Your code here\n}","python":"def swim_in_water(grid):\n    pass","java":"class Solution {\n    public int swimInWater(int[][] grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,2],[1,3]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use priority queue","Or binary search with BFS/DFS"]'::jsonb,
  61.8,
  '["Google","Amazon"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'best-meeting-point',
  'Best Meeting Point',
  'best-meeting-point',
  'hard',
  'Given an m x n binary grid grid where each 1 marks the home of one friend, return the minimal total travel distance. The total travel distance is the sum of the distances between the houses of the friends and the meeting point. The distance is calculated using Manhattan Distance.',
  '[{"input":"grid = [[1,0,0,0,1],[0,0,0,0,0],[0,0,1,0,0]]","output":"6"}]'::jsonb,
  '["m == grid.length","n == grid[i].length"]'::jsonb,
  '["Array","Math","Sorting","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function minTotalDistance(grid) {\n  // Your code here\n}","python":"def min_total_distance(grid):\n    pass","java":"class Solution {\n    public int minTotalDistance(int[][] grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,0,0,0,1],[0,0,0,0,0],[0,0,1,0,0]]","expectedOutput":"6","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Median minimizes sum of absolute deviations","Find median row and column separately"]'::jsonb,
  60.2,
  '["Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'game-of-life',
  'Game of Life',
  'game-of-life',
  'medium',
  'According to Wikipedia''s article: ''The Game of Life, also known simply as Life, is a cellular automaton devised by the British mathematician John Horton Conway in 1970.'' The board is made up of an m x n grid of cells, where each cell has an initial state: live (represented by a 1) or dead (represented by a 0). Given the current state of the m x n grid board, return the next state.',
  '[{"input":"board = [[0,1,0],[0,0,1],[1,1,1],[0,0,0]]","output":"[[0,0,0],[1,0,1],[0,1,1],[0,1,0]]"}]'::jsonb,
  '["m == board.length","n == board[i].length"]'::jsonb,
  '["Array","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function gameOfLife(board) {\n  // Your code here\n}","python":"def game_of_life(board):\n    pass","java":"class Solution {\n    public void gameOfLife(int[][] board) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,1,0],[0,0,1],[1,1,1],[0,0,0]]","expectedOutput":"[[0,0,0],[1,0,1],[0,1,1],[0,1,0]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use state encoding to track changes in-place","Count live neighbors for each cell"]'::jsonb,
  68.3,
  '["Amazon","Google","Dropbox"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'basic-calculator',
  'Basic Calculator',
  'basic-calculator',
  'hard',
  'Given a string s representing a valid expression, implement a basic calculator to evaluate it, and return the result of the evaluation. Note: You are not allowed to use any built-in function which evaluates strings as mathematical expressions, such as eval().',
  '[{"input":"s = \"1 + 1\"","output":"2"},{"input":"s = \" 2-1 + 2 \"","output":"3"},{"input":"s = \"(1+(4+5+2)-3)+(6+8)\"","output":"23"}]'::jsonb,
  '["1 <= s.length <= 3 * 10^5","s consists of digits, ''+'', ''-'', ''('', '')'', and '' ''"]'::jsonb,
  '["Math","String","Stack","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function calculate(s) {\n  // Your code here\n}","python":"def calculate(s):\n    pass","java":"class Solution {\n    public int calculate(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"1 + 1\"","expectedOutput":"2","hidden":false},{"id":"2","input":"\"(1+(4+5+2)-3)+(6+8)\"","expectedOutput":"23","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to handle parentheses","Track current number and sign"]'::jsonb,
  42.6,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-all-adjacent-duplicates-in-string',
  'Remove All Adjacent Duplicates In String',
  'remove-all-adjacent-duplicates-in-string',
  'easy',
  'You are given a string s consisting of lowercase English letters. A duplicate removal consists of choosing two adjacent and equal letters and removing them. We repeatedly make duplicate removals on s until we no longer can. Return the final string after all such duplicate removals have been made.',
  '[{"input":"s = \"abbaca\"","output":"\"ca\""},{"input":"s = \"azxxzy\"","output":"\"ay\""}]'::jsonb,
  '["1 <= s.length <= 10^5","s consists of lowercase English letters"]'::jsonb,
  '["String","Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function removeDuplicates(s) {\n  // Your code here\n}","python":"def remove_duplicates(s):\n    pass","java":"class Solution {\n    public String removeDuplicates(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abbaca\"","expectedOutput":"\"ca\"","hidden":false},{"id":"2","input":"\"azxxzy\"","expectedOutput":"\"ay\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to track characters","Pop when adjacent duplicates found"]'::jsonb,
  70.8,
  '["Amazon","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-remove-to-make-valid-parentheses',
  'Minimum Remove to Make Valid Parentheses',
  'minimum-remove-to-make-valid-parentheses',
  'medium',
  'Given a string s of ''('' , '')'' and lowercase English characters. Your task is to remove the minimum number of parentheses ( ''('' or '')'', in any positions ) so that the resulting parentheses string is valid and return any valid string.',
  '[{"input":"s = \"lee(t(c)o)de)\"","output":"\"lee(t(c)o)de\""},{"input":"s = \"a)b(c)d\"","output":"\"ab(c)d\""},{"input":"s = \"))((\"","output":"\"\""}]'::jsonb,
  '["1 <= s.length <= 10^5","s[i] is either''('' , '')'', or lowercase English letter"]'::jsonb,
  '["String","Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function minRemoveToMakeValid(s) {\n  // Your code here\n}","python":"def min_remove_to_make_valid(s):\n    pass","java":"class Solution {\n    public String minRemoveToMakeValid(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"lee(t(c)o)de)\"","expectedOutput":"\"lee(t(c)o)de\"","hidden":false},{"id":"2","input":"\"a)b(c)d\"","expectedOutput":"\"ab(c)d\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Track indices of invalid parentheses","Use stack to match pairs"]'::jsonb,
  67.4,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'exclusive-time-of-functions',
  'Exclusive Time of Functions',
  'exclusive-time-of-functions',
  'medium',
  'On a single-threaded CPU, we execute a program containing n functions. Each function has a unique ID between 0 and n-1. Function calls are stored in a log in the format {function_id}:{"start" | "end"}:{timestamp}. Return the exclusive time of each function in an array, where the value at the ith index represents the exclusive time for the function with ID i.',
  '[{"input":"n = 2, logs = [\"0:start:0\",\"1:start:2\",\"1:end:5\",\"0:end:6\"]","output":"[3,4]"}]'::jsonb,
  '["1 <= n <= 100","1 <= logs.length <= 500"]'::jsonb,
  '["Array","Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function exclusiveTime(n, logs) {\n  // Your code here\n}","python":"def exclusive_time(n, logs):\n    pass","java":"class Solution {\n    public int[] exclusiveTime(int n, List<String> logs) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"2, [\"0:start:0\",\"1:start:2\",\"1:end:5\",\"0:end:6\"]","expectedOutput":"[3,4]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to track function calls","Calculate time differences between events"]'::jsonb,
  60.8,
  '["Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'flatten-nested-list-iterator',
  'Flatten Nested List Iterator',
  'flatten-nested-list-iterator',
  'medium',
  'You are given a nested list of integers nestedList. Each element is either an integer or a list whose elements may also be integers or other lists. Implement an iterator to flatten it.',
  '[{"input":"nestedList = [[1,1],2,[1,1]]","output":"[1,1,2,1,1]"},{"input":"nestedList = [1,[4,[6]]]","output":"[1,4,6]"}]'::jsonb,
  '["1 <= nestedList.length <= 500"]'::jsonb,
  '["Stack","Tree","Depth-First Search","Design","Queue","Iterator"]'::jsonb,
  'DSA',
  '{"javascript":"class NestedIterator {\n  constructor(nestedList) {\n  }\n  hasNext() {\n  }\n  next() {\n  }\n}","python":"class NestedIterator:\n    def __init__(self, nestedList):\n        pass\n    def next(self):\n        pass\n    def hasNext(self):\n        pass","java":"public class NestedIterator implements Iterator<Integer> {\n    public NestedIterator(List<NestedInteger> nestedList) {\n    }\n    public Integer next() {\n    }\n    public boolean hasNext() {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1],2,[1,1]]","expectedOutput":"[1,1,2,1,1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to store nested lists","Process in reverse order"]'::jsonb,
  61.7,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'implement-queue-using-stacks',
  'Implement Queue Using Stacks',
  'implement-queue-using-stacks',
  'easy',
  'Implement a first in first out (FIFO) queue using only two stacks. The implemented queue should support all the functions of a normal queue (push, peek, pop, and empty).',
  '[{"input":"[\"MyQueue\", \"push\", \"push\", \"peek\", \"pop\", \"empty\"]\\n[[], [1], [2], [], [], []]","output":"[null, null, null, 1, 1, false]"}]'::jsonb,
  '["1 <= x <= 9","At most 100 calls will be made to push, pop, peek, and empty"]'::jsonb,
  '["Stack","Design","Queue"]'::jsonb,
  'DSA',
  '{"javascript":"class MyQueue {\n  constructor() {\n  }\n  push(x) {\n  }\n  pop() {\n  }\n  peek() {\n  }\n  empty() {\n  }\n}","python":"class MyQueue:\n    def __init__(self):\n        pass\n    def push(self, x):\n        pass\n    def pop(self):\n        pass\n    def peek(self):\n        pass\n    def empty(self):\n        pass","java":"class MyQueue {\n    public MyQueue() {\n    }\n    public void push(int x) {\n    }\n    public int pop() {\n    }\n    public int peek() {\n    }\n    public boolean empty() {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MyQueue\", \"push\", \"push\", \"peek\", \"pop\", \"empty\"], [[], [1], [2], [], [], []]","expectedOutput":"[null, null, null, 1, 1, false]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two stacks: input and output","Transfer elements when needed"]'::jsonb,
  65.2,
  '["Microsoft","Amazon","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'daily-temperatures',
  'Daily Temperatures',
  'daily-temperatures',
  'medium',
  'Given an array of integers temperatures represents the daily temperatures, return an array answer such that answer[i] is the number of days you have to wait after the ith day to get a warmer temperature. If there is no future day for which this is possible, keep answer[i] == 0 instead.',
  '[{"input":"temperatures = [73,74,75,71,69,72,76,73]","output":"[1,1,4,2,1,1,0,0]"},{"input":"temperatures = [30,40,50,60]","output":"[1,1,1,0]"}]'::jsonb,
  '["1 <= temperatures.length <= 10^5","30 <= temperatures[i] <= 100"]'::jsonb,
  '["Array","Stack","Monotonic Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function dailyTemperatures(temperatures) {\n  // Your code here\n}","python":"def daily_temperatures(temperatures):\n    pass","java":"class Solution {\n    public int[] dailyTemperatures(int[] temperatures) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[73,74,75,71,69,72,76,73]","expectedOutput":"[1,1,4,2,1,1,0,0]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use monotonic decreasing stack","Store indices in stack"]'::jsonb,
  66.3,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'decode-string',
  'Decode String',
  'decode-string',
  'medium',
  'Given an encoded string, return its decoded string. The encoding rule is: k[encoded_string], where the encoded_string inside the square brackets is being repeated exactly k times. Note that k is guaranteed to be a positive integer.',
  '[{"input":"s = \"3[a]2[bc]\"","output":"\"aaabcbc\""},{"input":"s = \"3[a2[c]]\"","output":"\"accaccacc\""},{"input":"s = \"2[abc]3[cd]ef\"","output":"\"abcabccdcdcdef\""}]'::jsonb,
  '["1 <= s.length <= 30","s consists of lowercase English letters, digits, and square brackets ''[]''"]'::jsonb,
  '["String","Stack","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function decodeString(s) {\n  // Your code here\n}","python":"def decode_string(s):\n    pass","java":"class Solution {\n    public String decodeString(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"3[a]2[bc]\"","expectedOutput":"\"aaabcbc\"","hidden":false},{"id":"2","input":"\"3[a2[c]]\"","expectedOutput":"\"accaccacc\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to handle nested patterns","Track numbers and strings separately"]'::jsonb,
  58.9,
  '["Google","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-string-length-after-removing-substrings',
  'Minimum String Length After Removing Substrings',
  'minimum-string-length-after-removing-substrings',
  'easy',
  'You are given a string s consisting only of uppercase English letters. You can apply some operations to this string where, in one operation, you can remove any occurrence of one of the substrings "AB" or "CD" from s. Return the minimum possible length of the resulting string that you can obtain.',
  '[{"input":"s = \"ABFCACDB\"","output":"2"},{"input":"s = \"ACBBD\"","output":"5"}]'::jsonb,
  '["1 <= s.length <= 100","s consists only of uppercase English letters"]'::jsonb,
  '["String","Stack","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function minLength(s) {\n  // Your code here\n}","python":"def min_length(s):\n    pass","java":"class Solution {\n    public int minLength(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"ABFCACDB\"","expectedOutput":"2","hidden":false},{"id":"2","input":"\"ACBBD\"","expectedOutput":"5","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to track characters","Check last character when adding new one"]'::jsonb,
  58.3,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-valid-subarrays',
  'Number of Valid Subarrays',
  'number-of-valid-subarrays',
  'hard',
  'Given an integer array nums, return the number of non-empty subarrays with the leftmost element not larger than other elements in the subarray. A subarray is a contiguous part of an array.',
  '[{"input":"nums = [1,4,2,5,3]","output":"11"},{"input":"nums = [3,2,1]","output":"3"}]'::jsonb,
  '["1 <= nums.length <= 5 * 10^4","0 <= nums[i] <= 10^5"]'::jsonb,
  '["Array","Stack","Monotonic Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function validSubarrays(nums) {\n  // Your code here\n}","python":"def valid_subarrays(nums):\n    pass","java":"class Solution {\n    public int validSubarrays(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,4,2,5,3]","expectedOutput":"11","hidden":false},{"id":"2","input":"[3,2,1]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use monotonic stack to find next smaller element","Count subarrays for each starting position"]'::jsonb,
  70.4,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-visible-people-in-a-queue',
  'Number of Visible People in a Queue',
  'number-of-visible-people-in-a-queue',
  'hard',
  'There are n people standing in a queue, and they numbered from 0 to n - 1 in left to right order. You are given an array heights of distinct integers where heights[i] represents the height of the ith person. A person can see another person to their right in the queue if everybody in between is shorter than both of them. Return an array answer of length n where answer[i] is the number of people the ith person can see to their right in the queue.',
  '[{"input":"heights = [10,6,8,5,11,9]","output":"[3,1,2,1,1,0]"},{"input":"heights = [5,1,2,3,10]","output":"[4,1,1,1,0]"}]'::jsonb,
  '["n == heights.length","1 <= n <= 10^5","1 <= heights[i] <= 10^5"]'::jsonb,
  '["Array","Stack","Monotonic Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function canSeePersonsCount(heights) {\n  // Your code here\n}","python":"def can_see_persons_count(heights):\n    pass","java":"class Solution {\n    public int[] canSeePersonsCount(int[] heights) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[10,6,8,5,11,9]","expectedOutput":"[3,1,2,1,1,0]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Process from right to left with monotonic stack","Count elements popped from stack"]'::jsonb,
  75.2,
  '["Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'parsing-a-boolean-expression',
  'Parsing a Boolean Expression',
  'parsing-a-boolean-expression',
  'hard',
  'A boolean expression is an expression that evaluates to either true or false. It can be in one of the following shapes: ''t'' that evaluates to true, ''f'' that evaluates to false, ''!(subExpr)'' that evaluates to the logical NOT of the inner expression subExpr, ''&(subExpr1, subExpr2, ..., subExprn)'' that evaluates to the logical AND of the inner expressions, ''|(subExpr1, subExpr2, ..., subExprn)'' that evaluates to the logical OR of the inner expressions. Given a string expression that represents a boolean expression, return the evaluation of that expression.',
  '[{"input":"expression = \"&(|(f))\"","output":"false"},{"input":"expression = \"|(f,f,f,t)\"","output":"true"}]'::jsonb,
  '["1 <= expression.length <= 2 * 10^4","expression[i] is one following characters: ''('', '')'', ''&'', ''|'', ''!'', ''t'', ''f'', and '',''"]'::jsonb,
  '["String","Stack","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function parseBoolExpr(expression) {\n  // Your code here\n}","python":"def parse_bool_expr(expression):\n    pass","java":"class Solution {\n    public boolean parseBoolExpr(String expression) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"&(|(f))\"","expectedOutput":"false","hidden":false},{"id":"2","input":"\"|(f,f,f,t)\"","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to handle nested expressions","Process operators when closing parenthesis found"]'::jsonb,
  59.3,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'remove-duplicate-letters',
  'Remove Duplicate Letters',
  'remove-duplicate-letters',
  'medium',
  'Given a string s, remove duplicate letters so that every letter appears once and only once. You must make sure your result is the smallest in lexicographical order among all possible results.',
  '[{"input":"s = \"bcabc\"","output":"\"abc\""},{"input":"s = \"cbacdcbc\"","output":"\"acdb\""}]'::jsonb,
  '["1 <= s.length <= 10^4","s consists of lowercase English letters"]'::jsonb,
  '["String","Stack","Greedy","Monotonic Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function removeDuplicateLetters(s) {\n  // Your code here\n}","python":"def remove_duplicate_letters(s):\n    pass","java":"class Solution {\n    public String removeDuplicateLetters(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"bcabc\"","expectedOutput":"\"abc\"","hidden":false},{"id":"2","input":"\"cbacdcbc\"","expectedOutput":"\"acdb\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use monotonic stack with character counts","Remove larger characters if they appear later"]'::jsonb,
  45.8,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'network-delay-time',
  'Network Delay Time',
  'network-delay-time',
  'medium',
  'You are given a network of n nodes, labeled from 1 to n. You are also given times, a list of travel times as directed edges times[i] = (ui, vi, wi), where ui is the source node, vi is the target node, and wi is the time it takes for a signal to travel from source to target. We will send a signal from a given node k. Return the minimum time it takes for all the n nodes to receive the signal. If it is impossible for all the n nodes to receive the signal, return -1.',
  '[{"input":"times = [[2,1,1],[2,3,1],[3,4,1]], n = 4, k = 2","output":"2"},{"input":"times = [[1,2,1]], n = 2, k = 1","output":"1"}]'::jsonb,
  '["1 <= k <= n <= 100","1 <= times.length <= 6000","times[i].length == 3"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Graph","Heap (Priority Queue)","Shortest Path"]'::jsonb,
  'DSA',
  '{"javascript":"function networkDelayTime(times, n, k) {\n  // Your code here\n}","python":"def network_delay_time(times, n, k):\n    pass","java":"class Solution {\n    public int networkDelayTime(int[][] times, int n, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[2,1,1],[2,3,1],[3,4,1]], 4, 2","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use Dijkstra''s algorithm","Track minimum time to reach each node"]'::jsonb,
  52.8,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-if-path-exists-in-graph',
  '1971. Find if Path Exists in Graph',
  'find-if-path-exists-in-graph',
  'easy',
  'There is a bi-directional graph with n vertices, where each vertex is labeled from 0 to n - 1 (inclusive). The edges in the graph are represented as a 2D integer array edges, where each edges[i] = [ui, vi] denotes a bi-directional edge between vertex ui and vertex vi. Every vertex pair is connected by at most one edge, and no vertex has an edge to itself. You want to determine if there is a valid path that exists from vertex source to vertex destination. Given edges and the integers n, source, and destination, return true if there is a valid path from source to destination, or false otherwise.',
  '[{"input":"n = 3, edges = [[0,1],[1,2],[2,0]], source = 0, destination = 2","output":"true"},{"input":"n = 6, edges = [[0,1],[0,2],[3,5],[5,4],[4,3]], source = 0, destination = 5","output":"false"}]'::jsonb,
  '["1 <= n <= 2 * 10^5","0 <= edges.length <= 2 * 10^5","edges[i].length == 2","0 <= ui, vi <= n - 1"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Union Find","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function validPath(n, edges, source, destination) {\n  // Your code here\n}","python":"def valid_path(n, edges, source, destination):\n    pass","java":"class Solution {\n    public boolean validPath(int n, int[][] edges, int source, int destination) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, [[0,1],[1,2],[2,0]], 0, 2","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use union find to check connectivity","Or use DFS/BFS"]'::jsonb,
  54.8,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'clone-graph',
  'Clone Graph',
  'clone-graph',
  'medium',
  'Given a reference of a node in a connected undirected graph, return a deep copy (clone) of the graph. Each node in the graph contains a value (int) and a list (List[Node]) of its neighbors.',
  '[{"input":"adjList = [[2,4],[1,3],[2,4],[1,3]]","output":"[[2,4],[1,3],[2,4],[1,3]]"},{"input":"adjList = [[]]","output":"[[]]"}]'::jsonb,
  '["The number of nodes in the graph is in the range [0, 100]","1 <= Node.val <= 100"]'::jsonb,
  '["Hash Table","Depth-First Search","Breadth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function cloneGraph(node) {\n  // Your code here\n}","python":"def clone_graph(node):\n    pass","java":"class Solution {\n    public Node cloneGraph(Node node) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[2,4],[1,3],[2,4],[1,3]]","expectedOutput":"[[2,4],[1,3],[2,4],[1,3]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use hashmap to map original to cloned nodes","Use DFS or BFS to traverse"]'::jsonb,
  54.2,
  '["Facebook","Amazon","Google","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'graph-valid-tree',
  'Graph Valid Tree',
  'graph-valid-tree',
  'medium',
  'You have a graph of n nodes labeled from 0 to n - 1. You are given an integer n and a list of edges where edges[i] = [ai, bi] indicates that there is an undirected edge between nodes ai and bi in the graph. Return true if the edges of the given graph make up a valid tree, and false otherwise.',
  '[{"input":"n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]","output":"true"},{"input":"n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]","output":"false"}]'::jsonb,
  '["1 <= n <= 2000","0 <= edges.length <= 5000"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Union Find","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function validTree(n, edges) {\n  // Your code here\n}","python":"def valid_tree(n, edges):\n    pass","java":"class Solution {\n    public boolean validTree(int n, int[][] edges) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"5, [[0,1],[0,2],[0,3],[1,4]]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["A tree has n-1 edges and no cycles","Check connectivity with DFS/BFS"]'::jsonb,
  46.3,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'bus-routes',
  'Bus Routes',
  'bus-routes',
  'hard',
  'You are given an array routes representing bus routes where routes[i] is a bus route that the ith bus repeats forever. You will start at the bus stop source (You are not on any bus initially), and you want to go to the bus stop target. You can travel between bus stops by buses only. Return the least number of buses you must take to travel from source to target. Return -1 if it is not possible.',
  '[{"input":"routes = [[1,2,7],[3,6,7]], source = 1, target = 6","output":"2"},{"input":"routes = [[7,12],[4,5,15],[6],[15,19],[9,12,13]], source = 15, target = 12","output":"-1"}]'::jsonb,
  '["1 <= routes.length <= 500","1 <= routes[i].length <= 10^5"]'::jsonb,
  '["Array","Hash Table","Breadth-First Search"]'::jsonb,
  'DSA',
  '{"javascript":"function numBusesToDestination(routes, source, target) {\n  // Your code here\n}","python":"def num_buses_to_destination(routes, source, target):\n    pass","java":"class Solution {\n    public int numBusesToDestination(int[][] routes, int source, int target) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2,7],[3,6,7]], 1, 6","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Model as graph where nodes are bus routes","BFS on bus routes, not stops"]'::jsonb,
  46.7,
  '["Google","Amazon","Facebook"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reconstruct-itinerary',
  'Reconstruct Itinerary',
  'reconstruct-itinerary',
  'hard',
  'You are given a list of airline tickets where tickets[i] = [fromi, toi] represent the departure and the arrival airports of one flight. Reconstruct the itinerary in order and return it. All of the tickets belong to a man who departs from "JFK", thus, the itinerary must begin with "JFK". If there are multiple valid itineraries, you should return the itinerary that has the smallest lexical order when read as a single string.',
  '[{"input":"tickets = [[\"MUC\",\"LHR\"],[\"JFK\",\"MUC\"],[\"SFO\",\"SJC\"],[\"LHR\",\"SFO\"]]","output":"[\"JFK\",\"MUC\",\"LHR\",\"SFO\",\"SJC\"]"},{"input":"tickets = [[\"JFK\",\"SFO\"],[\"JFK\",\"ATL\"],[\"SFO\",\"ATL\"],[\"ATL\",\"JFK\"],[\"ATL\",\"SFO\"]]","output":"[\"JFK\",\"ATL\",\"JFK\",\"SFO\",\"ATL\",\"SFO\"]"}]'::jsonb,
  '["1 <= tickets.length <= 300","tickets[i].length == 2"]'::jsonb,
  '["Depth-First Search","Graph","Eulerian Circuit"]'::jsonb,
  'DSA',
  '{"javascript":"function findItinerary(tickets) {\n  // Your code here\n}","python":"def find_itinerary(tickets):\n    pass","java":"class Solution {\n    public List<String> findItinerary(List<List<String>> tickets) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[\"MUC\",\"LHR\"],[\"JFK\",\"MUC\"],[\"SFO\",\"SJC\"],[\"LHR\",\"SFO\"]]","expectedOutput":"[\"JFK\",\"MUC\",\"LHR\",\"SFO\",\"SJC\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Hierholzer''s algorithm for Eulerian path","Sort destinations lexically"]'::jsonb,
  42.3,
  '["Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-the-town-judge',
  'Find the Town Judge',
  'find-the-town-judge',
  'easy',
  'In a town, there are n people labeled from 1 to n. There is a rumor that one of these people is secretly the town judge. If the town judge exists, then: The town judge trusts nobody. Everybody (except for the town judge) trusts the town judge. There is exactly one person that satisfies properties 1 and 2. You are given an array trust where trust[i] = [ai, bi] representing that the person labeled ai trusts the person labeled bi. Return the label of the town judge if the town judge exists and can be identified, or return -1 otherwise.',
  '[{"input":"n = 2, trust = [[1,2]]","output":"2"},{"input":"n = 3, trust = [[1,3],[2,3]]","output":"3"},{"input":"n = 3, trust = [[1,3],[2,3],[3,1]]","output":"-1"}]'::jsonb,
  '["1 <= n <= 1000","0 <= trust.length <= 10^4"]'::jsonb,
  '["Array","Hash Table","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function findJudge(n, trust) {\n  // Your code here\n}","python":"def find_judge(n, trust):\n    pass","java":"class Solution {\n    public int findJudge(int n, int[][] trust) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"2, [[1,2]]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count in-degree and out-degree","Judge has in-degree n-1 and out-degree 0"]'::jsonb,
  49.5,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-center-of-star-graph',
  'Find Center of Star Graph',
  'find-center-of-star-graph',
  'easy',
  'There is an undirected star graph consisting of n nodes labeled from 1 to n. A star graph is a graph where there is one center node and exactly n - 1 edges that connect the center node with every other node. You are given a 2D integer array edges where each edges[i] = [ui, vi] indicates that there is an edge between the nodes ui and vi. Return the center of the given star graph.',
  '[{"input":"edges = [[1,2],[2,3],[4,2]]","output":"2"},{"input":"edges = [[1,2],[5,1],[1,3],[1,4]]","output":"1"}]'::jsonb,
  '["3 <= n <= 10^5","edges.length == n - 1"]'::jsonb,
  '["Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function findCenter(edges) {\n  // Your code here\n}","python":"def find_center(edges):\n    pass","java":"class Solution {\n    public int findCenter(int[][] edges) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2],[2,3],[4,2]]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Center appears in all edges","Check first two edges"]'::jsonb,
  84.7,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'lucky-numbers-in-a-matrix',
  'Lucky Numbers in a Matrix',
  'lucky-numbers-in-a-matrix',
  'easy',
  'Given an m x n matrix of distinct numbers, return all lucky numbers in the matrix in any order. A lucky number is an element of the matrix such that it is the minimum element in its row and maximum in its column.',
  '[{"input":"matrix = [[3,7,8],[9,11,13],[15,16,17]]","output":"[15]"},{"input":"matrix = [[1,10,4,2],[9,3,8,7],[15,16,17,12]]","output":"[12]"}]'::jsonb,
  '["m == mat.length","n == mat[i].length","1 <= n, m <= 50"]'::jsonb,
  '["Array","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function luckyNumbers(matrix) {\n  // Your code here\n}","python":"def lucky_numbers(matrix):\n    pass","java":"class Solution {\n    public List<Integer> luckyNumbers(int[][] matrix) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[3,7,8],[9,11,13],[15,16,17]]","expectedOutput":"[15]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Find min in each row","Check if it''s max in its column"]'::jsonb,
  70.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'path-with-maximum-probability',
  'Path with Maximum Probability',
  'path-with-maximum-probability',
  'medium',
  'You are given an undirected weighted graph of n nodes (0-indexed), represented by an edge list where edges[i] = [a, b] is an undirected edge connecting the nodes a and b with a probability of success of traversing that edge succProb[i]. Given two nodes start and end, find the path with the maximum probability of success to go from start to end and return its success probability.',
  '[{"input":"n = 3, edges = [[0,1],[1,2],[0,2]], succProb = [0.5,0.5,0.2], start = 0, end = 2","output":"0.25000"}]'::jsonb,
  '["2 <= n <= 10^4","0 <= start, end < n"]'::jsonb,
  '["Array","Graph","Heap (Priority Queue)","Shortest Path"]'::jsonb,
  'DSA',
  '{"javascript":"function maxProbability(n, edges, succProb, start, end) {\n  // Your code here\n}","python":"def max_probability(n, edges, succ_prob, start, end):\n    pass","java":"class Solution {\n    public double maxProbability(int n, int[][] edges, double[] succProb, int start, int end) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, [[0,1],[1,2],[0,2]], [0.5,0.5,0.2], 0, 2","expectedOutput":"0.25000","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Modified Dijkstra with max heap","Multiply probabilities instead of adding"]'::jsonb,
  47.2,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'tree-diameter',
  'Tree Diameter',
  'tree-diameter',
  'medium',
  'The diameter of a tree is the number of edges in the longest path in that tree. There is an undirected tree of n nodes labeled from 0 to n - 1. You are given a 2D array edges where edges.length == n - 1 and edges[i] = [ai, bi] indicates that there is an undirected edge between nodes ai and bi in the tree. Return the diameter of the tree.',
  '[{"input":"edges = [[0,1],[0,2]]","output":"2"},{"input":"edges = [[0,1],[1,2],[2,3],[1,4],[4,5]]","output":"4"}]'::jsonb,
  '["n == edges.length + 1","1 <= n <= 10^4"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function treeDiameter(edges) {\n  // Your code here\n}","python":"def tree_diameter(edges):\n    pass","java":"class Solution {\n    public int treeDiameter(int[][] edges) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,1],[0,2]]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Two BFS: find farthest node, then farthest from that","Or DFS tracking max path through each node"]'::jsonb,
  65.3,
  '["Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reorder-routes-to-make-all-paths-lead-to-the-city-zero',
  'Reorder Routes to Make All Paths Lead to the City Zero',
  'reorder-routes-to-make-all-paths-lead-to-the-city-zero',
  'medium',
  'There are n cities numbered from 0 to n - 1 and n - 1 roads such that there is only one way to travel between two different cities. Roads are represented by connections where connections[i] = [ai, bi] represents a road from city ai to city bi. Return the minimum number of edges that need to be changed so that every city can reach city 0.',
  '[{"input":"n = 6, connections = [[0,1],[1,3],[2,3],[4,0],[4,5]]","output":"3"},{"input":"n = 5, connections = [[1,0],[1,2],[3,2],[3,4]]","output":"2"}]'::jsonb,
  '["2 <= n <= 5 * 10^4","connections.length == n - 1"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function minReorder(n, connections) {\n  // Your code here\n}","python":"def min_reorder(n, connections):\n    pass","java":"class Solution {\n    public int minReorder(int n, int[][] connections) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"6, [[0,1],[1,3],[2,3],[4,0],[4,5]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build bidirectional graph, mark original directions","DFS/BFS from 0, count edges going away"]'::jsonb,
  62.8,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-cost-to-make-at-least-one-valid-path-in-a-grid',
  'Minimum Cost to Make at Least One Valid Path in a Grid',
  'minimum-cost-to-make-at-least-one-valid-path-in-a-grid',
  'hard',
  'Given an m x n grid. Each cell of the grid has a sign pointing to the next cell you should visit if you are currently in this cell. Return the minimum cost to make the grid have at least one valid path which starts from the upper left cell to the bottom-right cell. The sign of grid[i][j] is: 1 which means go to the cell to the right, 2 which means go to the cell to the left, 3 means go to the lower cell, 4 means go to the upper cell. The cost of changing the sign is 1.',
  '[{"input":"grid = [[1,1,1,1],[2,2,2,2],[1,1,1,1],[2,2,2,2]]","output":"3"},{"input":"grid = [[1,1,3],[3,2,2],[1,1,4]]","output":"0"}]'::jsonb,
  '["m == grid.length","n == grid[i].length","1 <= m, n <= 100"]'::jsonb,
  '["Array","Breadth-First Search","Graph","Heap (Priority Queue)","Matrix","Shortest Path"]'::jsonb,
  'DSA',
  '{"javascript":"function minCost(grid) {\n  // Your code here\n}","python":"def min_cost(grid):\n    pass","java":"class Solution {\n    public int minCost(int[][] grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1,1,1],[2,2,2,2],[1,1,1,1],[2,2,2,2]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["0-1 BFS with deque","Following arrow has cost 0, changing has cost 1"]'::jsonb,
  61.5,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-cycle-in-a-graph',
  'Longest Cycle in a Graph',
  'longest-cycle-in-a-graph',
  'hard',
  'You are given a directed graph of n nodes numbered from 0 to n - 1, where each node has at most one outgoing edge. The graph is represented with a given 0-indexed array edges of size n, indicating that there is a directed edge from node i to node edges[i]. If there is no outgoing edge from node i, then edges[i] == -1. Return the length of the longest cycle in the graph. If no cycle exists, return -1.',
  '[{"input":"edges = [3,3,4,2,3]","output":"3"},{"input":"edges = [2,-1,3,1]","output":"-1"}]'::jsonb,
  '["n == edges.length","2 <= n <= 10^5","-1 <= edges[i] < n"]'::jsonb,
  '["Depth-First Search","Graph","Topological Sort"]'::jsonb,
  'DSA',
  '{"javascript":"function longestCycle(edges) {\n  // Your code here\n}","python":"def longest_cycle(edges):\n    pass","java":"class Solution {\n    public int longestCycle(int[] edges) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,3,4,2,3]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Track visit time for each node","Cycle length = current time - visit time"]'::jsonb,
  42.6,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'shortest-cycle-in-a-graph',
  'Shortest Cycle in a Graph',
  'shortest-cycle-in-a-graph',
  'hard',
  'There is a bi-directional graph with n vertices, where each vertex is labeled from 0 to n - 1. The edges in the graph are represented by a given 2D integer array edges, where edges[i] = [ui, vi] denotes an edge between vertex ui and vertex vi. Every vertex pair is connected by at most one edge, and no vertex has an edge to itself. Return the length of the shortest cycle in the graph. If no cycle exists, return -1.',
  '[{"input":"n = 7, edges = [[0,1],[1,2],[2,0],[3,4],[4,5],[5,6],[6,3]]","output":"3"},{"input":"n = 4, edges = [[0,1],[0,2]]","output":"-1"}]'::jsonb,
  '["2 <= n <= 1000","1 <= edges.length <= 1000"]'::jsonb,
  '["Breadth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function findShortestCycle(n, edges) {\n  // Your code here\n}","python":"def find_shortest_cycle(n, edges):\n    pass","java":"class Solution {\n    public int findShortestCycle(int n, int[][] edges) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"7, [[0,1],[1,2],[2,0],[3,4],[4,5],[5,6],[6,3]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["BFS from each node","When revisiting node, found cycle"]'::jsonb,
  44.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'flatten-binary-tree-to-linked-list',
  'Flatten Binary Tree to Linked List',
  'flatten-binary-tree-to-linked-list',
  'medium',
  'Given the root of a binary tree, flatten the tree into a "linked list": The "linked list" should use the same TreeNode class where the right child pointer points to the next node in the list and the left child pointer is always null. The "linked list" should be in the same order as a pre-order traversal of the binary tree.',
  '[{"input":"root = [1,2,5,3,4,null,6]","output":"[1,null,2,null,3,null,4,null,5,null,6]"},{"input":"root = []","output":"[]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 2000]","-100 <= Node.val <= 100"]'::jsonb,
  '["Linked List","Stack","Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function flatten(root) {\n  // Your code here\n}","python":"def flatten(root):\n    pass","java":"class Solution {\n    public void flatten(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,5,3,4,null,6]","expectedOutput":"[1,null,2,null,3,null,4,null,5,null,6]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use Morris traversal or recursion","Process right subtree before left"]'::jsonb,
  61.8,
  '["Microsoft","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'diameter-of-binary-tree',
  'Diameter of Binary Tree',
  'diameter-of-binary-tree',
  'easy',
  'Given the root of a binary tree, return the length of the diameter of the tree. The diameter of a binary tree is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root. The length of a path between two nodes is represented by the number of edges between them.',
  '[{"input":"root = [1,2,3,4,5]","output":"3"},{"input":"root = [1,2]","output":"1"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 10^4]","-100 <= Node.val <= 100"]'::jsonb,
  '["Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function diameterOfBinaryTree(root) {\n  // Your code here\n}","python":"def diameter_of_binary_tree(root):\n    pass","java":"class Solution {\n    public int diameterOfBinaryTree(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Track max diameter while calculating height","Diameter through node = left height + right height"]'::jsonb,
  57.3,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'serialize-and-deserialize-binary-tree',
  'Serialize and Deserialize Binary Tree',
  'serialize-and-deserialize-binary-tree',
  'hard',
  'Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment. Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.',
  '[{"input":"root = [1,2,3,null,null,4,5]","output":"[1,2,3,null,null,4,5]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 10^4]","-1000 <= Node.val <= 1000"]'::jsonb,
  '["String","Tree","Depth-First Search","Breadth-First Search","Design","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"class Codec {\n  serialize(root) {\n  }\n  deserialize(data) {\n  }\n}","python":"class Codec:\n    def serialize(self, root):\n        pass\n    def deserialize(self, data):\n        pass","java":"public class Codec {\n    public String serialize(TreeNode root) {\n    }\n    public TreeNode deserialize(String data) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,null,null,4,5]","expectedOutput":"[1,2,3,null,null,4,5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use preorder traversal with markers for null","Can use BFS or DFS approach"]'::jsonb,
  56.4,
  '["Amazon","Facebook","Google","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'invert-binary-tree',
  'Invert Binary Tree',
  'invert-binary-tree',
  'easy',
  'Given the root of a binary tree, invert the tree, and return its root. Inverting a binary tree means swapping the left and right children of all nodes in the tree.',
  '[{"input":"root = [4,2,7,1,3,6,9]","output":"[4,7,2,9,6,3,1]"},{"input":"root = [2,1,3]","output":"[2,3,1]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 100]","-100 <= Node.val <= 100"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function invertTree(root) {\n  // Your code here\n}","python":"def invert_tree(root):\n    pass","java":"class Solution {\n    public TreeNode invertTree(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,2,7,1,3,6,9]","expectedOutput":"[4,7,2,9,6,3,1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Swap left and right children recursively","Can use DFS or BFS"]'::jsonb,
  74.8,
  '["Google","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-tree-maximum-path-sum',
  'Binary Tree Maximum Path Sum',
  'binary-tree-maximum-path-sum',
  'hard',
  'A path in a binary tree is a sequence of nodes where each pair of adjacent nodes in the sequence has an edge connecting them. A node can only appear in the sequence at most once. Note that the path does not need to pass through the root. The path sum of a path is the sum of the node''s values in the path. Given the root of a binary tree, return the maximum path sum of any non-empty path.',
  '[{"input":"root = [1,2,3]","output":"6"},{"input":"root = [-10,9,20,null,null,15,7]","output":"42"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 3 * 10^4]","-1000 <= Node.val <= 1000"]'::jsonb,
  '["Dynamic Programming","Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function maxPathSum(root) {\n  // Your code here\n}","python":"def max_path_sum(root):\n    pass","java":"class Solution {\n    public int maxPathSum(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3]","expectedOutput":"6","hidden":false},{"id":"2","input":"[-10,9,20,null,null,15,7]","expectedOutput":"42","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Track global max and return max single path","At each node: max = node + max(left, 0) + max(right, 0)"]'::jsonb,
  39.2,
  '["Amazon","Facebook","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'convert-sorted-array-to-binary-search-tree',
  'Convert Sorted Array to Binary Search Tree',
  'convert-sorted-array-to-binary-search-tree',
  'easy',
  'Given an integer array nums where the elements are sorted in ascending order, convert it to a height-balanced binary search tree. A height-balanced binary tree is a binary tree in which the depth of the two subtrees of every node never differs by more than one.',
  '[{"input":"nums = [-10,-3,0,5,9]","output":"[0,-3,9,-10,null,5]"},{"input":"nums = [1,3]","output":"[3,1]"}]'::jsonb,
  '["1 <= nums.length <= 10^4","-10^4 <= nums[i] <= 10^4","nums is sorted in a strictly increasing order"]'::jsonb,
  '["Array","Divide and Conquer","Tree","Binary Search Tree","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function sortedArrayToBST(nums) {\n  // Your code here\n}","python":"def sorted_array_to_bst(nums):\n    pass","java":"class Solution {\n    public TreeNode sortedArrayToBST(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-10,-3,0,5,9]","expectedOutput":"[0,-3,9,-10,null,5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use middle element as root","Recursively build left and right subtrees"]'::jsonb,
  70.5,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'construct-binary-tree-from-preorder-and-inorder-traversal',
  'Build Binary Tree from Preorder and Inorder Traversal',
  'construct-binary-tree-from-preorder-and-inorder-traversal',
  'medium',
  'Given two integer arrays preorder and inorder where preorder is the preorder traversal of a binary tree and inorder is the inorder traversal of the same tree, construct and return the binary tree.',
  '[{"input":"preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]","output":"[3,9,20,null,null,15,7]"},{"input":"preorder = [-1], inorder = [-1]","output":"[-1]"}]'::jsonb,
  '["1 <= preorder.length <= 3000","inorder.length == preorder.length","-3000 <= preorder[i], inorder[i] <= 3000"]'::jsonb,
  '["Array","Hash Table","Divide and Conquer","Tree","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function buildTree(preorder, inorder) {\n  // Your code here\n}","python":"def build_tree(preorder, inorder):\n    pass","java":"class Solution {\n    public TreeNode buildTree(int[] preorder, int[] inorder) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,9,20,15,7], [9,3,15,20,7]","expectedOutput":"[3,9,20,null,null,15,7]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["First element in preorder is root","Find root in inorder to split left/right subtrees"]'::jsonb,
  61.2,
  '["Facebook","Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-tree-right-side-view',
  'Binary Tree Right Side View',
  'binary-tree-right-side-view',
  'medium',
  'Given the root of a binary tree, imagine yourself standing on the right side of it, return the values of the nodes you can see ordered from top to bottom.',
  '[{"input":"root = [1,2,3,null,5,null,4]","output":"[1,3,4]"},{"input":"root = [1,null,3]","output":"[1,3]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 100]","-100 <= Node.val <= 100"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function rightSideView(root) {\n  // Your code here\n}","python":"def right_side_view(root):\n    pass","java":"class Solution {\n    public List<Integer> rightSideView(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,null,5,null,4]","expectedOutput":"[1,3,4]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use level order traversal (BFS)","Or DFS with level tracking, visit right first"]'::jsonb,
  62.7,
  '["Amazon","Facebook","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'lowest-common-ancestor-of-a-binary-tree',
  'Lowest Common Ancestor of a Binary Tree',
  'lowest-common-ancestor-of-a-binary-tree',
  'medium',
  'Given a binary tree, find the lowest common ancestor (LCA) of two given nodes in the tree. According to the definition of LCA on Wikipedia: ''The lowest common ancestor is defined between two nodes p and q as the lowest node in T that has both p and q as descendants (where we allow a node to be a descendant of itself).''',
  '[{"input":"root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1","output":"3"},{"input":"root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4","output":"5"}]'::jsonb,
  '["The number of nodes in the tree is in the range [2, 10^5]","-10^9 <= Node.val <= 10^9","All Node.val are unique"]'::jsonb,
  '["Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function lowestCommonAncestor(root, p, q) {\n  // Your code here\n}","python":"def lowest_common_ancestor(root, p, q):\n    pass","java":"class Solution {\n    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,5,1,6,2,0,8,null,null,7,4], 5, 1","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["If root is p or q, return root","If p and q found in different subtrees, current node is LCA"]'::jsonb,
  59.8,
  '["Facebook","Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'validate-binary-search-tree',
  'Validate Binary Search Tree',
  'validate-binary-search-tree',
  'medium',
  'Given the root of a binary tree, determine if it is a valid binary search tree (BST). A valid BST is defined as follows: The left subtree of a node contains only nodes with keys less than the node''s key. The right subtree of a node contains only nodes with keys greater than the node''s key. Both the left and right subtrees must also be binary search trees.',
  '[{"input":"root = [2,1,3]","output":"true"},{"input":"root = [5,1,4,null,null,3,6]","output":"false"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 10^4]","-2^31 <= Node.val <= 2^31 - 1"]'::jsonb,
  '["Tree","Depth-First Search","Binary Search Tree","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function isValidBST(root) {\n  // Your code here\n}","python":"def is_valid_bst(root):\n    pass","java":"class Solution {\n    public boolean isValidBST(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,1,3]","expectedOutput":"true","hidden":false},{"id":"2","input":"[5,1,4,null,null,3,6]","expectedOutput":"false","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Pass min and max bounds down the tree","Or use inorder traversal and check if sorted"]'::jsonb,
  32.4,
  '["Amazon","Facebook","Microsoft","Google","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'nested-list-weight-sum-ii',
  'Nested List Weight Sum II',
  'nested-list-weight-sum-ii',
  'medium',
  'You are given a nested list of integers nestedList. Each element is either an integer or a list whose elements may also be integers or other lists. The depth of an integer is the number of lists that it is inside of. For example, the nested list [1,[2,2],[[3],2],1] has each integer''s value set to its depth. The depth of integer 1 is 1, the depth of integer 2 is 2, and the depth of integer 3 is 3. Return the sum of each integer in nestedList multiplied by its depth.',
  '[{"input":"nestedList = [[1,1],2,[1,1]]","output":"8"},{"input":"nestedList = [1,[4,[6]]]","output":"17"}]'::jsonb,
  '["1 <= nestedList.length <= 50"]'::jsonb,
  '["Stack","Depth-First Search","Breadth-First Search"]'::jsonb,
  'DSA',
  '{"javascript":"function depthSumInverse(nestedList) {\n  // Your code here\n}","python":"def depth_sum_inverse(nestedList):\n    pass","java":"class Solution {\n    public int depthSumInverse(List<NestedInteger> nestedList) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1],2,[1,1]]","expectedOutput":"8","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Find max depth first","Weight = max_depth - current_depth + 1"]'::jsonb,
  66.8,
  '["LinkedIn","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'inorder-successor-in-bst',
  'Inorder Successor in BST',
  'inorder-successor-in-bst',
  'medium',
  'Given the root of a binary search tree and a node p in it, return the in-order successor of that node in the BST. If the given node has no in-order successor in the tree, return null. The successor of a node p is the node with the smallest key greater than p.val.',
  '[{"input":"root = [2,1,3], p = 1","output":"2"},{"input":"root = [5,3,6,2,4,null,null,1], p = 6","output":"null"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 10^4]","-10^5 <= Node.val <= 10^5"]'::jsonb,
  '["Tree","Depth-First Search","Binary Search Tree","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function inorderSuccessor(root, p) {\n  // Your code here\n}","python":"def inorder_successor(root, p):\n    pass","java":"class Solution {\n    public TreeNode inorderSuccessor(TreeNode root, TreeNode p) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,1,3], 1","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["If p has right child, successor is leftmost in right subtree","Otherwise, track last node where we went left"]'::jsonb,
  48.7,
  '["Facebook","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'height-of-binary-tree-after-subtree-removal-queries',
  'Height of Binary Tree After Subtree Removal Queries',
  'height-of-binary-tree-after-subtree-removal-queries',
  'hard',
  'You are given the root of a binary tree with n nodes. Each node is assigned a unique value from 1 to n. You are also given an array queries of size m. You have to perform m independent queries on the tree where in the ith query you do the following: Remove the subtree rooted at the node with the value queries[i] from the tree. It is guaranteed that queries[i] will not be equal to the value of the root. Return an array answer of size m where answer[i] is the height of the tree after performing the ith query.',
  '[{"input":"root = [1,3,4,2,null,6,5,null,null,null,null,null,7], queries = [4]","output":"[2]"}]'::jsonb,
  '["The number of nodes in the tree is n","2 <= n <= 10^5","1 <= Node.val <= n"]'::jsonb,
  '["Array","Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function treeQueries(root, queries) {\n  // Your code here\n}","python":"def tree_queries(root, queries):\n    pass","java":"class Solution {\n    public int[] treeQueries(TreeNode root, int[] queries) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,3,4,2,null,6,5,null,null,null,null,null,7], [4]","expectedOutput":"[2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Precompute heights and depths","Track max heights excluding each subtree"]'::jsonb,
  42.8,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'delete-nodes-and-return-forest',
  'Delete Nodes And Return Forest',
  'delete-nodes-and-return-forest',
  'medium',
  'Given the root of a binary tree, each node in the tree has a distinct value. After deleting all nodes with a value in to_delete, we are left with a forest (a disjoint union of trees). Return the roots of the trees in the remaining forest. You may return the result in any order.',
  '[{"input":"root = [1,2,3,4,5,6,7], to_delete = [3,5]","output":"[[1,2,null,4],[6],[7]]"}]'::jsonb,
  '["The number of nodes in the given tree is at most 1000","Each node has a distinct value between 1 and 1000","to_delete.length <= 1000"]'::jsonb,
  '["Array","Hash Table","Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function delNodes(root, to_delete) {\n  // Your code here\n}","python":"def del_nodes(root, to_delete):\n    pass","java":"class Solution {\n    public List<TreeNode> delNodes(TreeNode root, int[] to_delete) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5,6,7], [3,5]","expectedOutput":"[[1,2,null,4],[6],[7]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use DFS with set of values to delete","If node deleted, add children to result if not null"]'::jsonb,
  69.4,
  '["Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sum-of-distances-in-tree',
  'Sum of Distances in a Tree',
  'sum-of-distances-in-tree',
  'hard',
  'There is an undirected connected tree with n nodes labeled from 0 to n - 1 and n - 1 edges. You are given the integer n and the array edges where edges[i] = [ai, bi] indicates that there is an edge between nodes ai and bi in the tree. Return an array answer of length n where answer[i] is the sum of the distances between the ith node in the tree and all other nodes.',
  '[{"input":"n = 6, edges = [[0,1],[0,2],[2,3],[2,4],[2,5]]","output":"[8,12,6,10,10,10]"}]'::jsonb,
  '["1 <= n <= 3 * 10^4","edges.length == n - 1"]'::jsonb,
  '["Dynamic Programming","Tree","Depth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function sumOfDistancesInTree(n, edges) {\n  // Your code here\n}","python":"def sum_of_distances_in_tree(n, edges):\n    pass","java":"class Solution {\n    public int[] sumOfDistancesInTree(int n, int[][] edges) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"6, [[0,1],[0,2],[2,3],[2,4],[2,5]]","expectedOutput":"[8,12,6,10,10,10]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Two DFS passes: compute subtree sums, then reroot","Use rerooting technique"]'::jsonb,
  57.3,
  '["Google","Facebook"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'recover-a-tree-from-preorder-traversal',
  'Recover a Tree From Preorder Traversal',
  'recover-a-tree-from-preorder-traversal',
  'hard',
  'We run a preorder depth-first search (DFS) on the root of a binary tree. At each node in this traversal, we output D dashes (where D is the depth of this node), then we output the value of this node. If the depth of a node is D, the depth of its immediate child is D + 1. The depth of the root node is 0. If a node has only one child, that child is guaranteed to be the left child. Given the output traversal of this traversal, recover the tree and return its root.',
  '[{"input":"traversal = \"1-2--3--4-5--6--7\"","output":"[1,2,5,3,4,6,7]"},{"input":"traversal = \"1-2--3---4-5--6---7\"","output":"[1,2,5,3,null,6,null,4,null,7]"}]'::jsonb,
  '["The number of nodes in the original tree is in the range [1, 1000]","1 <= Node.val <= 10^9"]'::jsonb,
  '["String","Tree","Depth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function recoverFromPreorder(traversal) {\n  // Your code here\n}","python":"def recover_from_preorder(traversal):\n    pass","java":"class Solution {\n    public TreeNode recoverFromPreorder(String traversal) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"1-2--3--4-5--6--7\"","expectedOutput":"[1,2,5,3,4,6,7]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to track nodes at each depth","Count dashes to determine depth"]'::jsonb,
  74.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-depth-of-binary-tree',
  'Maximum Depth of Binary Tree',
  'maximum-depth-of-binary-tree',
  'easy',
  'Given the root of a binary tree, return its maximum depth. A binary tree''s maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.',
  '[{"input":"root = [3,9,20,null,null,15,7]","output":"3"},{"input":"root = [1,null,2]","output":"2"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 10^4]","-100 <= Node.val <= 100"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function maxDepth(root) {\n  // Your code here\n}","python":"def max_depth(root):\n    pass","java":"class Solution {\n    public int maxDepth(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,9,20,null,null,15,7]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use recursion: 1 + max(left depth, right depth)","Or use BFS and count levels"]'::jsonb,
  75.2,
  '["Amazon","Microsoft","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'kth-smallest-element-in-a-bst',
  'Kth Smallest Element in a BST',
  'kth-smallest-element-in-a-bst',
  'medium',
  'Given the root of a binary search tree, and an integer k, return the kth smallest value (1-indexed) of all the values of the nodes in the tree.',
  '[{"input":"root = [3,1,4,null,2], k = 1","output":"1"},{"input":"root = [5,3,6,2,4,null,null,1], k = 3","output":"3"}]'::jsonb,
  '["The number of nodes in the tree is n","1 <= k <= n <= 10^4","0 <= Node.val <= 10^4"]'::jsonb,
  '["Tree","Depth-First Search","Binary Search Tree","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function kthSmallest(root, k) {\n  // Your code here\n}","python":"def kth_smallest(root, k):\n    pass","java":"class Solution {\n    public int kthSmallest(TreeNode root, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,1,4,null,2], 1","expectedOutput":"1","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Inorder traversal gives sorted order","Return kth element during inorder"]'::jsonb,
  71.8,
  '["Amazon","Facebook","Google","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-tree-level-order-traversal',
  'Binary Tree Level Order Traversal',
  'binary-tree-level-order-traversal',
  'medium',
  'Given the root of a binary tree, return the level order traversal of its nodes'' values. (i.e., from left to right, level by level).',
  '[{"input":"root = [3,9,20,null,null,15,7]","output":"[[3],[9,20],[15,7]]"},{"input":"root = [1]","output":"[[1]]"},{"input":"root = []","output":"[]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 2000]","-1000 <= Node.val <= 1000"]'::jsonb,
  '["Tree","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function levelOrder(root) {\n  // Your code here\n}","python":"def level_order(root):\n    pass","java":"class Solution {\n    public List<List<Integer>> levelOrder(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,9,20,null,null,15,7]","expectedOutput":"[[3],[9,20],[15,7]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use queue for BFS","Track level size to group nodes"]'::jsonb,
  66.2,
  '["Amazon","Microsoft","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'binary-tree-zigzag-level-order-traversal',
  'Binary Tree Zigzag Level Order Traversal',
  'binary-tree-zigzag-level-order-traversal',
  'medium',
  'Given the root of a binary tree, return the zigzag level order traversal of its nodes'' values. (i.e., from left to right, then right to left for the next level and alternate between).',
  '[{"input":"root = [3,9,20,null,null,15,7]","output":"[[3],[20,9],[15,7]]"},{"input":"root = [1]","output":"[[1]]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 2000]","-100 <= Node.val <= 100"]'::jsonb,
  '["Tree","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function zigzagLevelOrder(root) {\n  // Your code here\n}","python":"def zigzag_level_order(root):\n    pass","java":"class Solution {\n    public List<List<Integer>> zigzagLevelOrder(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,9,20,null,null,15,7]","expectedOutput":"[[3],[20,9],[15,7]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use BFS with alternating direction flag","Reverse level values on alternate levels"]'::jsonb,
  58.4,
  '["Amazon","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'populating-next-right-pointers-in-each-node',
  'Populating Next Right Pointers in Each Node',
  'populating-next-right-pointers-in-each-node',
  'medium',
  'You are given a perfect binary tree where all leaves are on the same level, and every parent has two children. Populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set to NULL. Initially, all next pointers are set to NULL.',
  '[{"input":"root = [1,2,3,4,5,6,7]","output":"[1,#,2,3,#,4,5,6,7,#]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 2^12 - 1]","-1000 <= Node.val <= 1000"]'::jsonb,
  '["Linked List","Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function connect(root) {\n  // Your code here\n}","python":"def connect(root):\n    pass","java":"class Solution {\n    public Node connect(Node root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5,6,7]","expectedOutput":"[1,#,2,3,#,4,5,6,7,#]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use level order traversal","Or connect using parent''s next pointer"]'::jsonb,
  61.7,
  '["Microsoft","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'vertical-order-traversal-of-a-binary-tree',
  'Vertical Order Traversal of a Binary Tree',
  'vertical-order-traversal-of-a-binary-tree',
  'hard',
  'Given the root of a binary tree, calculate the vertical order traversal of the binary tree. For each node at position (row, col), its left and right children will be at positions (row + 1, col - 1) and (row + 1, col + 1) respectively. The root of the tree is at (0, 0). The vertical order traversal is a list of top-to-bottom orderings for each column index starting from the leftmost column and ending on the rightmost column. If two nodes are in the same row and column, the order should be from left to right.',
  '[{"input":"root = [3,9,20,null,null,15,7]","output":"[[9],[3,15],[20],[7]]"},{"input":"root = [1,2,3,4,5,6,7]","output":"[[4],[2],[1,5,6],[3],[7]]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 1000]","0 <= Node.val <= 1000"]'::jsonb,
  '["Hash Table","Tree","Depth-First Search","Breadth-First Search","Sorting","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function verticalTraversal(root) {\n  // Your code here\n}","python":"def vertical_traversal(root):\n    pass","java":"class Solution {\n    public List<List<Integer>> verticalTraversal(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,9,20,null,null,15,7]","expectedOutput":"[[9],[3,15],[20],[7]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use hashmap to group by column","Sort by row, then by value within same position"]'::jsonb,
  47.3,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'symmetric-tree',
  'Symmetric Tree',
  'symmetric-tree',
  'easy',
  'Given the root of a binary tree, check whether it is a mirror of itself (i.e., symmetric around its center).',
  '[{"input":"root = [1,2,2,3,4,4,3]","output":"true"},{"input":"root = [1,2,2,null,3,null,3]","output":"false"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 1000]","-100 <= Node.val <= 100"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function isSymmetric(root) {\n  // Your code here\n}","python":"def is_symmetric(root):\n    pass","java":"class Solution {\n    public boolean isSymmetric(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,2,3,4,4,3]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Compare left subtree with right subtree","Check if left.left mirrors right.right"]'::jsonb,
  56.8,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'word-ladder',
  'Word Ladder',
  'word-ladder',
  'hard',
  'A transformation sequence from word beginWord to word endWord using a dictionary wordList is a sequence of words beginWord -> s1 -> s2 -> ... -> sk such that: Every adjacent pair of words differs by a single letter. Every si for 1 <= i <= k is in wordList. Note that beginWord does not need to be in wordList. sk == endWord. Given two words, beginWord and endWord, and a dictionary wordList, return the number of words in the shortest transformation sequence from beginWord to endWord, or 0 if no such sequence exists.',
  '[{"input":"beginWord = \"hit\", endWord = \"cog\", wordList = [\"hot\",\"dot\",\"dog\",\"lot\",\"log\",\"cog\"]","output":"5"},{"input":"beginWord = \"hit\", endWord = \"cog\", wordList = [\"hot\",\"dot\",\"dog\",\"lot\",\"log\"]","output":"0"}]'::jsonb,
  '["1 <= beginWord.length <= 10","endWord.length == beginWord.length","1 <= wordList.length <= 5000"]'::jsonb,
  '["Hash Table","String","Breadth-First Search"]'::jsonb,
  'DSA',
  '{"javascript":"function ladderLength(beginWord, endWord, wordList) {\n  // Your code here\n}","python":"def ladder_length(beginWord, endWord, wordList):\n    pass","java":"class Solution {\n    public int ladderLength(String beginWord, String endWord, List<String> wordList) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"hit\", \"cog\", [\"hot\",\"dot\",\"dog\",\"lot\",\"log\",\"cog\"]","expectedOutput":"5","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use BFS with word set","Generate neighbors by changing each character"]'::jsonb,
  38.7,
  '["Amazon","Facebook","Google","Microsoft"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'two-sum-iv-input-is-a-bst',
  'Two Sum IV - Input is a BST',
  'two-sum-iv-input-is-a-bst',
  'easy',
  'Given the root of a Binary Search Tree and a target number k, return true if there exist two elements in the BST such that their sum is equal to the given target.',
  '[{"input":"root = [5,3,6,2,4,null,7], k = 9","output":"true"},{"input":"root = [5,3,6,2,4,null,7], k = 28","output":"false"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 10^4]","-10^4 <= Node.val <= 10^4"]'::jsonb,
  '["Hash Table","Two Pointers","Tree","Depth-First Search","Breadth-First Search","Binary Search Tree","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function findTarget(root, k) {\n  // Your code here\n}","python":"def find_target(root, k):\n    pass","java":"class Solution {\n    public boolean findTarget(TreeNode root, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[5,3,6,2,4,null,7], 9","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use inorder traversal + two pointers","Or use hash set while traversing"]'::jsonb,
  61.3,
  '["Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-minimum-diameter-after-merging-two-trees',
  'Find Minimum Diameter After Merging Two Trees',
  'find-minimum-diameter-after-merging-two-trees',
  'hard',
  'There exist two undirected trees with n and m nodes, numbered from 0 to n - 1 and from 0 to m - 1, respectively. You are given two 2D integer arrays edges1 and edges2 of lengths n - 1 and m - 1, respectively, where edges1[i] = [ai, bi] indicates that there is an edge between nodes ai and bi in the first tree and edges2[i] = [ui, vi] indicates that there is an edge between nodes ui and vi in the second tree. You must connect one node from the first tree with another node from the second tree with an edge. Return the minimum possible diameter of the resulting tree.',
  '[{"input":"edges1 = [[0,1],[0,2],[0,3]], edges2 = [[0,1]]","output":"3"},{"input":"edges1 = [[0,1],[0,2],[0,3],[2,4],[2,5],[3,6],[2,7]], edges2 = [[0,1],[0,2],[0,3],[2,4],[2,5],[3,6],[2,7]]","output":"5"}]'::jsonb,
  '["1 <= n, m <= 10^5","edges1.length == n - 1","edges2.length == m - 1"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumDiameterAfterMerge(edges1, edges2) {\n  // Your code here\n}","python":"def minimum_diameter_after_merge(edges1, edges2):\n    pass","java":"class Solution {\n    public int minimumDiameterAfterMerge(int[][] edges1, int[][] edges2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,1],[0,2],[0,3]], [[0,1]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Find diameter and radius of each tree","Connect centers for minimum diameter"]'::jsonb,
  38.5,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'closest-node-to-path-in-tree',
  'Closest Node to Path in Tree',
  'closest-node-to-path-in-tree',
  'hard',
  'You are given a tree with n nodes numbered from 0 to n - 1 in the form of a parent array parent where parent[i] is the parent of the ith node. The root of the tree is node 0, so parent[0] = -1 since it has no parent. You are also given a string s of length n where s[i] is the character assigned to node i. You are given an integer array queries of length m where queries[i] = [starti, endi, nodei]. For the ith query, find the node on the path from starti to endi that is closest to nodei. Return an array answer of length m where answer[i] is the answer to the ith query.',
  '[{"input":"parent = [-1,0,0,1,1,2], s = ''abcdef'', queries = [[0,5,2],[5,0,0]]","output":"[2,0]"}]'::jsonb,
  '["n == parent.length == s.length","2 <= n <= 10^5","0 <= parent[i] <= n - 1 for all i >= 1"]'::jsonb,
  '["Array","String","Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function closestNode(parent, s, queries) {\n  // Your code here\n}","python":"def closest_node(parent, s, queries):\n    pass","java":"class Solution {\n    public int[] closestNode(int[] parent, String s, int[][] queries) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-1,0,0,1,1,2], ''abcdef'', [[0,5,2],[5,0,0]]","expectedOutput":"[2,0]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Find path between start and end","Calculate distances from node to path nodes"]'::jsonb,
  45.2,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'frog-position-after-t-seconds',
  'Frog Position After T Seconds',
  'frog-position-after-t-seconds',
  'hard',
  'Given an undirected tree consisting of n vertices numbered from 1 to n. A frog starts jumping from vertex 1. In one second, the frog jumps from its current vertex to another unvisited vertex if they are directly connected. The frog can not jump back to a visited vertex. In case the frog can jump to several vertices, it jumps randomly to one of them with the same probability. Otherwise, when the frog can not jump to any unvisited vertex, it jumps forever on the same vertex. The edges of the undirected tree are given in the array edges, where edges[i] = [ai, bi] means that exists an edge connecting the vertices ai and bi. Return the probability that after t seconds the frog is on the vertex target.',
  '[{"input":"n = 7, edges = [[1,2],[1,3],[1,7],[2,4],[2,6],[3,5]], t = 2, target = 4","output":"0.16666666666666666"}]'::jsonb,
  '["1 <= n <= 100","edges.length == n - 1","1 <= ai, bi <= n"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function frogPosition(n, edges, t, target) {\n  // Your code here\n}","python":"def frog_position(n, edges, t, target):\n    pass","java":"class Solution {\n    public double frogPosition(int n, int[][] edges, int t, int target) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"7, [[1,2],[1,3],[1,7],[2,4],[2,6],[3,5]], 2, 4","expectedOutput":"0.16666666666666666","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["BFS with probability tracking","Probability = parent_prob / unvisited_neighbors"]'::jsonb,
  36.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'average-of-levels-in-binary-tree',
  'Average of Levels in Binary Tree',
  'average-of-levels-in-binary-tree',
  'easy',
  'Given the root of a binary tree, return the average value of the nodes on each level in the form of an array. Answers within 10^-5 of the actual answer will be accepted.',
  '[{"input":"root = [3,9,20,null,null,15,7]","output":"[3.00000,14.50000,11.00000]"},{"input":"root = [3,9,20,15,7]","output":"[3.00000,14.50000,11.00000]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [1, 10^4]","-2^31 <= Node.val <= 2^31 - 1"]'::jsonb,
  '["Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function averageOfLevels(root) {\n  // Your code here\n}","python":"def average_of_levels(root):\n    pass","java":"class Solution {\n    public List<Double> averageOfLevels(TreeNode root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,9,20,null,null,15,7]","expectedOutput":"[3.00000,14.50000,11.00000]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use level order traversal","Calculate sum and count for each level"]'::jsonb,
  70.5,
  '["Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'populating-next-right-pointers-in-each-node-ii',
  'Connect All Siblings of a Binary Tree (Similar to 117 - Populating Next Right Pointers in Each Node II)',
  'populating-next-right-pointers-in-each-node-ii',
  'medium',
  'Given a binary tree, populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set to NULL. Initially, all next pointers are set to NULL. Note: You may only use constant extra space. The recursive approach is fine. You may assume implicit stack space does not count as extra space for this problem.',
  '[{"input":"root = [1,2,3,4,5,null,7]","output":"[1,#,2,3,#,4,5,7,#]"}]'::jsonb,
  '["The number of nodes in the tree is in the range [0, 6000]","-100 <= Node.val <= 100"]'::jsonb,
  '["Linked List","Tree","Depth-First Search","Breadth-First Search","Binary Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function connect(root) {\n  // Your code here\n}","python":"def connect(root):\n    pass","java":"class Solution {\n    public Node connect(Node root) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,4,5,null,7]","expectedOutput":"[1,#,2,3,#,4,5,7,#]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Level order traversal without queue","Use established next pointers to traverse"]'::jsonb,
  52.3,
  '["Microsoft","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'implement-trie-prefix-tree',
  '208. Implement Trie (Prefix Tree)',
  'implement-trie-prefix-tree',
  'medium',
  'A trie (pronounced as ''try'') or prefix tree is a tree data structure used to efficiently store and retrieve keys in a dataset of strings. There are various applications of this data structure, such as autocomplete and spellchecker. Implement the Trie class: Trie() Initializes the trie object. void insert(String word) Inserts the string word into the trie. boolean search(String word) Returns true if the string word is in the trie (i.e., was inserted before), and false otherwise. boolean startsWith(String prefix) Returns true if there is a previously inserted string word that has the prefix prefix, and false otherwise.',
  '[{"input":"[\"Trie\", \"insert\", \"search\", \"search\", \"startsWith\", \"insert\", \"search\"]\\n[[], [\"apple\"], [\"apple\"], [\"app\"], [\"app\"], [\"app\"], [\"app\"]]","output":"[null, null, true, false, true, null, true]"}]'::jsonb,
  '["1 <= word.length, prefix.length <= 2000","word and prefix consist only of lowercase English letters"]'::jsonb,
  '["Hash Table","String","Design","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"class Trie {\n  constructor() {\n  }\n  insert(word) {\n  }\n  search(word) {\n  }\n  startsWith(prefix) {\n  }\n}","python":"class Trie:\n    def __init__(self):\n        pass\n    def insert(self, word):\n        pass\n    def search(self, word):\n        pass\n    def starts_with(self, prefix):\n        pass","java":"class Trie {\n    public Trie() {\n    }\n    public void insert(String word) {\n    }\n    public boolean search(String word) {\n    }\n    public boolean startsWith(String prefix) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"Trie\", \"insert\", \"search\", \"search\", \"startsWith\", \"insert\", \"search\"], [[], [\"apple\"], [\"apple\"], [\"app\"], [\"app\"], [\"app\"], [\"app\"]]","expectedOutput":"[null, null, true, false, true, null, true]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use nested hash maps or TrieNode objects","Mark end of word with a flag"]'::jsonb,
  63.7,
  '["Amazon","Microsoft","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'search-suggestions-system',
  '1268. Search Suggestions System',
  'search-suggestions-system',
  'medium',
  'You are given an array of strings products and a string searchWord. Design a system that suggests at most three product names from products after each character of searchWord is typed. Suggested products should have common prefix with searchWord. If there are more than three products with a common prefix return the three lexicographically minimums products. Return a list of lists of the suggested products after each character of searchWord is typed.',
  '[{"input":"products = [\"mobile\",\"mouse\",\"moneypot\",\"monitor\",\"mousepad\"], searchWord = \"mouse\"","output":"[[\"mobile\",\"moneypot\",\"monitor\"],[\"mobile\",\"moneypot\",\"monitor\"],[\"mouse\",\"mousepad\"],[\"mouse\",\"mousepad\"],[\"mouse\",\"mousepad\"]]"}]'::jsonb,
  '["1 <= products.length <= 1000","1 <= products[i].length <= 3000","1 <= searchWord.length <= 1000"]'::jsonb,
  '["Array","String","Trie","Sorting","Heap (Priority Queue)"]'::jsonb,
  'DSA',
  '{"javascript":"function suggestedProducts(products, searchWord) {\n  // Your code here\n}","python":"def suggested_products(products, searchWord):\n    pass","java":"class Solution {\n    public List<List<String>> suggestedProducts(String[] products, String searchWord) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"mobile\",\"mouse\",\"moneypot\",\"monitor\",\"mousepad\"], \"mouse\"","expectedOutput":"[[\"mobile\",\"moneypot\",\"monitor\"],[\"mobile\",\"moneypot\",\"monitor\"],[\"mouse\",\"mousepad\"],[\"mouse\",\"mousepad\"],[\"mouse\",\"mousepad\"]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort products then use binary search","Or build trie and DFS for suggestions"]'::jsonb,
  66.8,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'replace-words',
  '648. Replace Words',
  'replace-words',
  'medium',
  'In English, we have a concept called root, which can be followed by some other word to form another longer word - let''s call this word derivative. For example, when the root ''help'' is followed by the word ''ful'', we can form a derivative ''helpful''. Given a dictionary consisting of many roots and a sentence consisting of words separated by spaces, replace all the derivatives in the sentence with the root forming it. If a derivative can be replaced by more than one root, replace it with the root that has the shortest length. Return the sentence after the replacement.',
  '[{"input":"dictionary = [\"cat\",\"bat\",\"rat\"], sentence = \"the cattle was rattled by the battery\"","output":"\"the cat was rat by the bat\""}]'::jsonb,
  '["1 <= dictionary.length <= 1000","1 <= dictionary[i].length <= 100","1 <= sentence.length <= 10^6"]'::jsonb,
  '["Array","Hash Table","String","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"function replaceWords(dictionary, sentence) {\n  // Your code here\n}","python":"def replace_words(dictionary, sentence):\n    pass","java":"class Solution {\n    public String replaceWords(List<String> dictionary, String sentence) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"cat\",\"bat\",\"rat\"], \"the cattle was rattled by the battery\"","expectedOutput":"\"the cat was rat by the bat\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build trie from dictionary","For each word, find shortest prefix in trie"]'::jsonb,
  63.2,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-add-and-search-words-data-structure',
  '211. Design Add and Search Words Data Structure',
  'design-add-and-search-words-data-structure',
  'medium',
  'Design a data structure that supports adding new words and finding if a string matches any previously added string. Implement the WordDictionary class: WordDictionary() Initializes the object. void addWord(word) Adds word to the data structure, it can be matched later. bool search(word) Returns true if there is any string in the data structure that matches word or false otherwise. word may contain dots ''.'' where dots can be matched with any letter.',
  '[{"input":"[\"WordDictionary\",\"addWord\",\"addWord\",\"addWord\",\"search\",\"search\",\"search\",\"search\"]\\n[[],[\"bad\"],[\"dad\"],[\"mad\"],[\"pad\"],[\"bad\"],[\".ad\"],[\"b..\"]]","output":"[null,null,null,null,false,true,true,true]"}]'::jsonb,
  '["1 <= word.length <= 25","word in addWord consists of lowercase English letters","word in search consist of ''.'' or lowercase English letters"]'::jsonb,
  '["String","Depth-First Search","Design","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"class WordDictionary {\n  constructor() {\n  }\n  addWord(word) {\n  }\n  search(word) {\n  }\n}","python":"class WordDictionary:\n    def __init__(self):\n        pass\n    def add_word(self, word):\n        pass\n    def search(self, word):\n        pass","java":"class WordDictionary {\n    public WordDictionary() {\n    }\n    public void addWord(String word) {\n    }\n    public boolean search(String word) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"WordDictionary\",\"addWord\",\"addWord\",\"addWord\",\"search\",\"search\",\"search\",\"search\"], [[],[\"bad\"],[\"dad\"],[\"mad\"],[\"pad\"],[\"bad\"],[\".ad\"],[\"b..\"]]","expectedOutput":"[null,null,null,null,false,true,true,true]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use trie with DFS for wildcard search","For ''.'', try all possible children"]'::jsonb,
  47.8,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'word-search-ii',
  '212. Word Search II',
  'word-search-ii',
  'hard',
  'Given an m x n board of characters and a list of strings words, return all words on the board. Each word must be constructed from letters of sequentially adjacent cells, where adjacent cells are horizontally or vertically neighboring. The same letter cell may not be used more than once in a word.',
  '[{"input":"board = [[\"o\",\"a\",\"a\",\"n\"],[\"e\",\"t\",\"a\",\"e\"],[\"i\",\"h\",\"k\",\"r\"],[\"i\",\"f\",\"l\",\"v\"]], words = [\"oath\",\"pea\",\"eat\",\"rain\"]","output":"[\"eat\",\"oath\"]"}]'::jsonb,
  '["m == board.length","n == board[i].length","1 <= m, n <= 12","1 <= words.length <= 3 * 10^4"]'::jsonb,
  '["Array","String","Backtracking","Trie","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function findWords(board, words) {\n  // Your code here\n}","python":"def find_words(board, words):\n    pass","java":"class Solution {\n    public List<String> findWords(char[][] board, String[] words) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[\"o\",\"a\",\"a\",\"n\"],[\"e\",\"t\",\"a\",\"e\"],[\"i\",\"h\",\"k\",\"r\"],[\"i\",\"f\",\"l\",\"v\"]], [\"oath\",\"pea\",\"eat\",\"rain\"]","expectedOutput":"[\"eat\",\"oath\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build trie from words","DFS on board with trie matching"]'::jsonb,
  37.8,
  '["Amazon","Google","Microsoft","Facebook"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'top-k-frequent-words',
  '692. Top K Frequent Words',
  'top-k-frequent-words',
  'medium',
  'Given an array of strings words and an integer k, return the k most frequent strings. Return the answer sorted by the frequency from highest to lowest. Sort the words with the same frequency by their lexicographical order.',
  '[{"input":"words = [\"i\",\"love\",\"leetcode\",\"i\",\"love\",\"coding\"], k = 2","output":"[\"i\",\"love\"]"},{"input":"words = [\"the\",\"day\",\"is\",\"sunny\",\"the\",\"the\",\"the\",\"sunny\",\"is\",\"is\"], k = 4","output":"[\"the\",\"is\",\"sunny\",\"day\"]"}]'::jsonb,
  '["1 <= words.length <= 500","1 <= words[i].length <= 10","words[i] consists of lowercase English letters","k is in the range [1, The number of unique words[i]]"]'::jsonb,
  '["Hash Table","String","Trie","Sorting","Heap (Priority Queue)","Bucket Sort","Counting"]'::jsonb,
  'DSA',
  '{"javascript":"function topKFrequent(words, k) {\n  // Your code here\n}","python":"def top_k_frequent(words, k):\n    pass","java":"class Solution {\n    public List<String> topKFrequent(String[] words, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"i\",\"love\",\"leetcode\",\"i\",\"love\",\"coding\"], 2","expectedOutput":"[\"i\",\"love\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count frequencies with hashmap","Use min heap with custom comparator"]'::jsonb,
  56.3,
  '["Amazon","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-common-prefix',
  '14. Longest Common Prefix',
  'longest-common-prefix',
  'easy',
  'Write a function to find the longest common prefix string amongst an array of strings. If there is no common prefix, return an empty string ''''.',
  '[{"input":"strs = [\"flower\",\"flow\",\"flight\"]","output":"\"fl\""},{"input":"strs = [\"dog\",\"racecar\",\"car\"]","output":"\"\""}]'::jsonb,
  '["1 <= strs.length <= 200","0 <= strs[i].length <= 200","strs[i] consists of only lowercase English letters"]'::jsonb,
  '["String","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"function longestCommonPrefix(strs) {\n  // Your code here\n}","python":"def longest_common_prefix(strs):\n    pass","java":"class Solution {\n    public String longestCommonPrefix(String[] strs) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"flower\",\"flow\",\"flight\"]","expectedOutput":"\"fl\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Compare characters at each position","Or use trie to find common path"]'::jsonb,
  42.7,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'index-pairs-of-a-string',
  '1065. Index Pairs of a String',
  'index-pairs-of-a-string',
  'easy',
  'Given a string text and an array of strings words, return an array of all index pairs [i, j] so that the substring text[i...j] is in words. Return the pairs in sorted order (i.e., sort them by their first coordinate, and in case of ties sort them by their second coordinate).',
  '[{"input":"text = \"thestoryofleetcodeandme\", words = [\"story\",\"fleet\",\"leetcode\"]","output":"[[3,7],[9,13],[10,17]]"}]'::jsonb,
  '["1 <= text.length <= 100","1 <= words.length <= 20","1 <= words[i].length <= 50"]'::jsonb,
  '["Array","String","Trie","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function indexPairs(text, words) {\n  // Your code here\n}","python":"def index_pairs(text, words):\n    pass","java":"class Solution {\n    public int[][] indexPairs(String text, String[] words) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"thestoryofleetcodeandme\", [\"story\",\"fleet\",\"leetcode\"]","expectedOutput":"[[3,7],[9,13],[10,17]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build trie from words","For each position in text, search in trie"]'::jsonb,
  68.4,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'k-th-smallest-in-lexicographical-order',
  '440. K-th Smallest in Lexicographical Order',
  'k-th-smallest-in-lexicographical-order',
  'hard',
  'Given two integers n and k, return the kth lexicographically smallest integer in the range [1, n].',
  '[{"input":"n = 13, k = 2","output":"10"},{"input":"n = 1, k = 1","output":"1"}]'::jsonb,
  '["1 <= k <= n <= 10^9"]'::jsonb,
  '["Trie"]'::jsonb,
  'DSA',
  '{"javascript":"function findKthNumber(n, k) {\n  // Your code here\n}","python":"def find_kth_number(n, k):\n    pass","java":"class Solution {\n    public int findKthNumber(int n, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"13, 2","expectedOutput":"10","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Think of numbers as 10-ary tree","Count nodes in subtrees to skip"]'::jsonb,
  31.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'palindrome-pairs',
  '336. Palindrome Pairs',
  'palindrome-pairs',
  'hard',
  'You are given a 0-indexed array of unique strings words. A palindrome pair is a pair of integers (i, j) such that: 0 <= i, j < words.length, i != j, and words[i] + words[j] (the concatenation of the two strings) is a palindrome. Return an array of all the palindrome pairs of words.',
  '[{"input":"words = [\"abcd\",\"dcba\",\"lls\",\"s\",\"sssll\"]","output":"[[0,1],[1,0],[3,2],[2,4]]"},{"input":"words = [\"bat\",\"tab\",\"cat\"]","output":"[[0,1],[1,0]]"}]'::jsonb,
  '["1 <= words.length <= 5000","0 <= words[i].length <= 300"]'::jsonb,
  '["Array","Hash Table","String","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"function palindromePairs(words) {\n  // Your code here\n}","python":"def palindrome_pairs(words):\n    pass","java":"class Solution {\n    public List<List<Integer>> palindromePairs(String[] words) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"abcd\",\"dcba\",\"lls\",\"s\",\"sssll\"]","expectedOutput":"[[0,1],[1,0],[3,2],[2,4]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use trie with reversed words","Check for palindrome prefixes and suffixes"]'::jsonb,
  37.2,
  '["Google","Amazon","Airbnb"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-common-suffix-queries',
  '3093. Longest Common Suffix Queries',
  'longest-common-suffix-queries',
  'hard',
  'You are given two arrays of strings wordsContainer and wordsQuery. For each wordsQuery[i], you need to find a string from wordsContainer that has the longest common suffix with wordsQuery[i]. If there are multiple strings from wordsContainer with the longest common suffix, find the string with minimum length. If there are more than one such string with the same length, find the string that appeared earlier in wordsContainer. Return an array of integers ans, where ans[i] is the index of the string in wordsContainer that has the longest common suffix with wordsQuery[i].',
  '[{"input":"wordsContainer = [\"abcd\",\"bcd\",\"xbcd\"], wordsQuery = [\"cd\",\"bcd\",\"xyz\"]","output":"[1,1,1]"}]'::jsonb,
  '["1 <= wordsContainer.length, wordsQuery.length <= 10^4","1 <= wordsContainer[i].length, wordsQuery[i].length <= 5 * 10^3"]'::jsonb,
  '["Array","String","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"function longestCommonSuffix(wordsContainer, wordsQuery) {\n  // Your code here\n}","python":"def longest_common_suffix(wordsContainer, wordsQuery):\n    pass","java":"class Solution {\n    public int[] longestCommonSuffix(String[] wordsContainer, String[] wordsQuery) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"abcd\",\"bcd\",\"xbcd\"], [\"cd\",\"bcd\",\"xyz\"]","expectedOutput":"[1,1,1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build trie with reversed strings","Track shortest word at each node"]'::jsonb,
  28.5,
  '["Google"]'::jsonb,
  3,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'max-xor-pairs',
  '677. Max XOR Pairs',
  'max-xor-pairs',
  'medium',
  'Given an integer array nums, find the maximum result of nums[i] XOR nums[j], where 0 <= i <= j < n. Note: This is problem 421 in LeetCode (Maximum XOR of Two Numbers in an Array).',
  '[{"input":"nums = [3,10,5,25,2,8]","output":"28"},{"input":"nums = [14,70,53,83,49,91,36,80,92,51,66,70]","output":"127"}]'::jsonb,
  '["1 <= nums.length <= 2 * 10^5","0 <= nums[i] <= 2^31 - 1"]'::jsonb,
  '["Array","Hash Table","Bit Manipulation","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"function findMaximumXOR(nums) {\n  // Your code here\n}","python":"def find_maximum_xor(nums):\n    pass","java":"class Solution {\n    public int findMaximumXOR(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[3,10,5,25,2,8]","expectedOutput":"28","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build binary trie from numbers","For each number, find opposite bits in trie"]'::jsonb,
  55.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'check-if-a-word-occurs-as-a-prefix-of-any-word-in-a-sentence',
  '1455. Check If a Word Occurs As a Prefix of Any Word in a Sentence',
  'check-if-a-word-occurs-as-a-prefix-of-any-word-in-a-sentence',
  'easy',
  'Given a sentence that consists of some words separated by a single space, and a searchWord, check if searchWord is a prefix of any word in sentence. Return the index of the word in sentence (1-indexed) where searchWord is a prefix of this word. If searchWord is a prefix of more than one word, return the index of the first word (minimum index). If there is no such word return -1.',
  '[{"input":"sentence = \"i love eating burger\", searchWord = \"burg\"","output":"4"},{"input":"sentence = \"this problem is an easy problem\", searchWord = \"pro\"","output":"2"}]'::jsonb,
  '["1 <= sentence.length <= 100","1 <= searchWord.length <= 10"]'::jsonb,
  '["String","String Matching"]'::jsonb,
  'DSA',
  '{"javascript":"function isPrefixOfWord(sentence, searchWord) {\n  // Your code here\n}","python":"def is_prefix_of_word(sentence, searchWord):\n    pass","java":"class Solution {\n    public int isPrefixOfWord(String sentence, String searchWord) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"i love eating burger\", \"burg\"","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Split sentence into words","Check each word with startsWith"]'::jsonb,
  66.2,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-word-with-all-prefixes',
  '1858. Longest Word With All Prefixes',
  'longest-word-with-all-prefixes',
  'medium',
  'Given an array of strings words, find the longest string in words such that every prefix of it is also in words. Return the string with the longest length. If more than one string has the same length, return the lexicographically smallest one. If no string has all its prefixes in words, return an empty string.',
  '[{"input":"words = [\"k\",\"ki\",\"kir\",\"kira\", \"kiran\"]","output":"\"kiran\""},{"input":"words = [\"a\", \"banana\", \"app\", \"appl\", \"ap\", \"apply\", \"apple\"]","output":"\"apple\""}]'::jsonb,
  '["1 <= words.length <= 10^5","1 <= words[i].length <= 10^5"]'::jsonb,
  '["Array","String","Trie","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function longestWord(words) {\n  // Your code here\n}","python":"def longest_word(words):\n    pass","java":"class Solution {\n    public String longestWord(String[] words) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"k\",\"ki\",\"kir\",\"kira\", \"kiran\"]","expectedOutput":"\"kiran\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build trie and mark word endings","DFS to find longest complete word path"]'::jsonb,
  47.3,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'lexicographical-numbers',
  '386. Lexicographical Numbers',
  'lexicographical-numbers',
  'medium',
  'Given an integer n, return all the numbers in the range [1, n] sorted in lexicographical order.',
  '[{"input":"n = 13","output":"[1,10,11,12,13,2,3,4,5,6,7,8,9]"},{"input":"n = 2","output":"[1,2]"}]'::jsonb,
  '["1 <= n <= 5 * 10^4"]'::jsonb,
  '["Depth-First Search","Trie"]'::jsonb,
  'DSA',
  '{"javascript":"function lexicalOrder(n) {\n  // Your code here\n}","python":"def lexical_order(n):\n    pass","java":"class Solution {\n    public List<Integer> lexicalOrder(int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"13","expectedOutput":"[1,10,11,12,13,2,3,4,5,6,7,8,9]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["DFS from 1 to 9","For each number, try appending 0-9"]'::jsonb,
  62.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-hashmap',
  '706. Design HashMap',
  'design-hashmap',
  'easy',
  'Design a HashMap without using any built-in hash table libraries. Implement the MyHashMap class: MyHashMap() initializes the object with an empty map. void put(int key, int value) inserts a (key, value) pair into the HashMap. If the key already exists in the map, update the corresponding value. int get(int key) returns the value to which the specified key is mapped, or -1 if this map contains no mapping for the key. void remove(key) removes the key and its corresponding value if the map contains the mapping for the key.',
  '[{"input":"[\"MyHashMap\", \"put\", \"put\", \"get\", \"get\", \"put\", \"get\", \"remove\", \"get\"]\\n[[], [1, 1], [2, 2], [1], [3], [2, 1], [2], [2], [2]]","output":"[null, null, null, 1, -1, null, 1, null, -1]"}]'::jsonb,
  '["0 <= key, value <= 10^6","At most 10^4 calls will be made to put, get, and remove"]'::jsonb,
  '["Array","Hash Table","Linked List","Design","Hash Function"]'::jsonb,
  'DSA',
  '{"javascript":"class MyHashMap {\n  constructor() {\n  }\n  put(key, value) {\n  }\n  get(key) {\n  }\n  remove(key) {\n  }\n}","python":"class MyHashMap:\n    def __init__(self):\n        pass\n    def put(self, key, value):\n        pass\n    def get(self, key):\n        pass\n    def remove(self, key):\n        pass","java":"class MyHashMap {\n    public MyHashMap() {\n    }\n    public void put(int key, int value) {\n    }\n    public int get(int key) {\n    }\n    public void remove(int key) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MyHashMap\", \"put\", \"put\", \"get\", \"get\", \"put\", \"get\", \"remove\", \"get\"], [[], [1, 1], [2, 2], [1], [3], [2, 1], [2], [2], [2]]","expectedOutput":"[null, null, null, 1, -1, null, 1, null, -1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use array with buckets","Handle collisions with linked lists"]'::jsonb,
  66.8,
  '["Amazon","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'fraction-to-recurring-decimal',
  '166. Fraction to Recurring Decimal',
  'fraction-to-recurring-decimal',
  'medium',
  'Given two integers representing the numerator and denominator of a fraction, return the fraction in string format. If the fractional part is repeating, enclose the repeating part in parentheses. If multiple answers are possible, return any of them. It is guaranteed that the length of the answer string is less than 10^4 for all the given inputs.',
  '[{"input":"numerator = 1, denominator = 2","output":"\"0.5\""},{"input":"numerator = 2, denominator = 1","output":"\"2\""},{"input":"numerator = 4, denominator = 333","output":"\"0.(012)\""}]'::jsonb,
  '["-2^31 <= numerator, denominator <= 2^31 - 1","denominator != 0"]'::jsonb,
  '["Hash Table","Math","String"]'::jsonb,
  'DSA',
  '{"javascript":"function fractionToDecimal(numerator, denominator) {\n  // Your code here\n}","python":"def fraction_to_decimal(numerator, denominator):\n    pass","java":"class Solution {\n    public String fractionToDecimal(int numerator, int denominator) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"1, 2","expectedOutput":"\"0.5\"","hidden":false},{"id":"2","input":"4, 333","expectedOutput":"\"0.(012)\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use hashmap to detect remainder cycle","Handle negative numbers and integer part separately"]'::jsonb,
  24.8,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'logger-rate-limiter',
  '359. Logger Rate Limiter',
  'logger-rate-limiter',
  'easy',
  'Design a logger system that receives a stream of messages along with their timestamps. Each unique message should only be printed at most every 10 seconds (i.e. a message printed at timestamp t will prevent other identical messages from being printed until timestamp t + 10). All messages will come in chronological order. Several messages may arrive at the same timestamp. Implement the Logger class: Logger() Initializes the logger object. bool shouldPrintMessage(int timestamp, string message) Returns true if the message should be printed in the given timestamp, otherwise returns false.',
  '[{"input":"[\"Logger\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\"]\\n[[], [1, \"foo\"], [2, \"bar\"], [3, \"foo\"], [8, \"bar\"], [10, \"foo\"], [11, \"foo\"]]","output":"[null, true, true, false, false, false, true]"}]'::jsonb,
  '["0 <= timestamp <= 10^9","Every timestamp will be passed in non-decreasing order"]'::jsonb,
  '["Hash Table","Design"]'::jsonb,
  'DSA',
  '{"javascript":"class Logger {\n  constructor() {\n  }\n  shouldPrintMessage(timestamp, message) {\n  }\n}","python":"class Logger:\n    def __init__(self):\n        pass\n    def should_print_message(self, timestamp, message):\n        pass","java":"class Logger {\n    public Logger() {\n    }\n    public boolean shouldPrintMessage(int timestamp, String message) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"Logger\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\", \"shouldPrintMessage\"], [[], [1, \"foo\"], [2, \"bar\"], [3, \"foo\"], [8, \"bar\"], [10, \"foo\"], [11, \"foo\"]]","expectedOutput":"[null, true, true, false, false, false, true]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Store message with last printed timestamp","Check if current time >= last time + 10"]'::jsonb,
  74.2,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'next-greater-element-i',
  '496. Next Greater Element I',
  'next-greater-element-i',
  'easy',
  'The next greater element of some element x in an array is the first greater element that is to the right of x in the same array. You are given two distinct 0-indexed integer arrays nums1 and nums2, where nums1 is a subset of nums2. For each 0 <= i < nums1.length, find the index j such that nums1[i] == nums2[j] and determine the next greater element of nums2[j] in nums2. If there is no next greater element, then the answer for this query is -1. Return an array ans of length nums1.length such that ans[i] is the next greater element as described above.',
  '[{"input":"nums1 = [4,1,2], nums2 = [1,3,4,2]","output":"[-1,3,-1]"},{"input":"nums1 = [2,4], nums2 = [1,2,3,4]","output":"[3,-1]"}]'::jsonb,
  '["1 <= nums1.length <= nums2.length <= 1000","0 <= nums1[i], nums2[i] <= 10^4"]'::jsonb,
  '["Array","Hash Table","Stack","Monotonic Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function nextGreaterElement(nums1, nums2) {\n  // Your code here\n}","python":"def next_greater_element(nums1, nums2):\n    pass","java":"class Solution {\n    public int[] nextGreaterElement(int[] nums1, int[] nums2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,1,2], [1,3,4,2]","expectedOutput":"[-1,3,-1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack to find next greater for nums2","Store results in hashmap"]'::jsonb,
  71.3,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'isomorphic-strings',
  '205. Isomorphic Strings',
  'isomorphic-strings',
  'easy',
  'Given two strings s and t, determine if they are isomorphic. Two strings s and t are isomorphic if the characters in s can be replaced to get t. All occurrences of a character must be replaced with another character while preserving the order of characters. No two characters may map to the same character, but a character may map to itself.',
  '[{"input":"s = \"egg\", t = \"add\"","output":"true"},{"input":"s = \"foo\", t = \"bar\"","output":"false"},{"input":"s = \"paper\", t = \"title\"","output":"true"}]'::jsonb,
  '["1 <= s.length <= 5 * 10^4","t.length == s.length"]'::jsonb,
  '["Hash Table","String"]'::jsonb,
  'DSA',
  '{"javascript":"function isIsomorphic(s, t) {\n  // Your code here\n}","python":"def is_isomorphic(s, t):\n    pass","java":"class Solution {\n    public boolean isIsomorphic(String s, String t) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"egg\", \"add\"","expectedOutput":"true","hidden":false},{"id":"2","input":"\"foo\", \"bar\"","expectedOutput":"false","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two hashmaps for bidirectional mapping","Check both s->t and t->s mappings"]'::jsonb,
  44.7,
  '["Amazon","Microsoft","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-duplicate-file-in-system',
  '609. Find Duplicate File in System',
  'find-duplicate-file-in-system',
  'medium',
  'Given a list paths of directory info, including the directory path, and all the files with contents in this directory, return all the duplicate files in the file system in terms of their paths. You may return the answer in any order. A group of duplicate files consists of at least two files that have the same content.',
  '[{"input":"paths = [\"root/a 1.txt(abcd) 2.txt(efgh)\",\"root/c 3.txt(abcd)\",\"root/c/d 4.txt(efgh)\",\"root 4.txt(efgh)\"]","output":"[[\"root/a/2.txt\",\"root/c/d/4.txt\",\"root/4.txt\"],[\"root/a/1.txt\",\"root/c/3.txt\"]]"}]'::jsonb,
  '["1 <= paths.length <= 2 * 10^4","1 <= paths[i].length <= 3000"]'::jsonb,
  '["Array","Hash Table","String"]'::jsonb,
  'DSA',
  '{"javascript":"function findDuplicate(paths) {\n  // Your code here\n}","python":"def find_duplicate(paths):\n    pass","java":"class Solution {\n    public List<List<String>> findDuplicate(String[] paths) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"root/a 1.txt(abcd) 2.txt(efgh)\",\"root/c 3.txt(abcd)\",\"root/c/d 4.txt(efgh)\",\"root 4.txt(efgh)\"]","expectedOutput":"[[\"root/a/2.txt\",\"root/c/d/4.txt\",\"root/4.txt\"],[\"root/a/1.txt\",\"root/c/3.txt\"]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Parse each path string","Group files by content using hashmap"]'::jsonb,
  64.8,
  '["Dropbox","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'high-five',
  '1086. High Five',
  'high-five',
  'easy',
  'Given a list of the scores of different students, items, where items[i] = [IDi, scorei] represents one score from a student with IDi, calculate each student''s top five average. Return the answer as an array of pairs result, where result[j] = [IDj, topFiveAveragej] represents the student with IDj and their top five average. Sort result by IDj in increasing order.',
  '[{"input":"items = [[1,91],[1,92],[2,93],[2,97],[1,60],[2,77],[1,65],[1,87],[1,100],[2,100],[2,76]]","output":"[[1,87],[2,88]]"}]'::jsonb,
  '["1 <= items.length <= 1000","items[i].length == 2","1 <= IDi <= 1000","0 <= scorei <= 100"]'::jsonb,
  '["Array","Hash Table","Sorting","Heap (Priority Queue)"]'::jsonb,
  'DSA',
  '{"javascript":"function highFive(items) {\n  // Your code here\n}","python":"def high_five(items):\n    pass","java":"class Solution {\n    public int[][] highFive(int[][] items) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,91],[1,92],[2,93],[2,97],[1,60],[2,77],[1,65],[1,87],[1,100],[2,100],[2,76]]","expectedOutput":"[[1,87],[2,88]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Group scores by student ID","Sort and take top 5 scores"]'::jsonb,
  77.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'bulls-and-cows',
  '299. Bulls and Cows',
  'bulls-and-cows',
  'medium',
  'You are playing the Bulls and Cows game with your friend. You write down a secret number and ask your friend to guess what the number is. When your friend makes a guess, you provide a hint with the following info: The number of ''bulls'', which are digits in the guess that are in the correct position. The number of ''cows'', which are digits in the guess that are in your secret number but are located in the wrong position. Given the secret number secret and your friend''s guess guess, return the hint for your friend''s guess.',
  '[{"input":"secret = \"1807\", guess = \"7810\"","output":"\"1A3B\""},{"input":"secret = \"1123\", guess = \"0111\"","output":"\"1A1B\""}]'::jsonb,
  '["1 <= secret.length, guess.length <= 1000","secret.length == guess.length"]'::jsonb,
  '["Hash Table","String","Counting"]'::jsonb,
  'DSA',
  '{"javascript":"function getHint(secret, guess) {\n  // Your code here\n}","python":"def get_hint(secret, guess):\n    pass","java":"class Solution {\n    public String getHint(String secret, String guess) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"1807\", \"7810\"","expectedOutput":"\"1A3B\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count bulls in first pass","Count remaining digits for cows"]'::jsonb,
  48.3,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'custom-sort-string',
  '791. Custom Sort String',
  'custom-sort-string',
  'medium',
  'You are given two strings order and s. All the characters of order are unique and were sorted in some custom order previously. Permute the characters of s so that they match the order that order was sorted. More specifically, if a character x occurs before a character y in order, then x should occur before y in the permuted string. Return any permutation of s that satisfies this property.',
  '[{"input":"order = \"cba\", s = \"abcd\"","output":"\"dcba\""},{"input":"order = \"bcafg\", s = \"abcd\"","output":"\"bcad\""}]'::jsonb,
  '["1 <= order.length <= 26","1 <= s.length <= 200"]'::jsonb,
  '["Hash Table","String","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function customSortString(order, s) {\n  // Your code here\n}","python":"def custom_sort_string(order, s):\n    pass","java":"class Solution {\n    public String customSortString(String order, String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"cba\", \"abcd\"","expectedOutput":"\"dcba\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count characters in s","Build result following order"]'::jsonb,
  70.3,
  '["Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-atoms',
  '694. Number of Atoms',
  'number-of-atoms',
  'hard',
  'Given a string formula representing a chemical formula, return the count of each atom. The atomic element always starts with an uppercase character, then zero or more lowercase letters, representing the name. One or more digits representing that element''s count may follow if the count is greater than 1. If the count is 1, no digits will follow. Two formulas are concatenated together to produce another formula. A formula placed in parentheses, and a count (optionally added) is also a formula. Return the count of all elements as a string in the following form: the first name (in sorted order), followed by its count (if that count is more than 1), followed by the second name (in sorted order), followed by its count (if that count is more than 1), and so on.',
  '[{"input":"formula = \"H2O\"","output":"\"H2O\""},{"input":"formula = \"Mg(OH)2\"","output":"\"H2MgO2\""},{"input":"formula = \"K4(ON(SO3)2)2\"","output":"\"K4N2O14S4\""}]'::jsonb,
  '["1 <= formula.length <= 1000","formula consists of English letters, digits, ''('', and '')''"]'::jsonb,
  '["Hash Table","String","Stack","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function countOfAtoms(formula) {\n  // Your code here\n}","python":"def count_of_atoms(formula):\n    pass","java":"class Solution {\n    public String countOfAtoms(String formula) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"H2O\"","expectedOutput":"\"H2O\"","hidden":false},{"id":"2","input":"\"K4(ON(SO3)2)2\"","expectedOutput":"\"K4N2O14S4\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use stack for parentheses","Multiply counts when closing parenthesis"]'::jsonb,
  53.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-wonderful-substrings',
  '1915. Number of Wonderful Substrings',
  'number-of-wonderful-substrings',
  'medium',
  'A wonderful string is a string where at most one letter appears an odd number of times. For example, ''ccjjc'' and ''abab'' are wonderful, but ''ab'' is not. Given a string word that consists of the first ten lowercase English letters (''a'' through ''j''), return the number of wonderful non-empty substrings in word. If the same substring appears multiple times in word, then count each occurrence separately.',
  '[{"input":"word = \"aba\"","output":"4"},{"input":"word = \"aabb\"","output":"9"}]'::jsonb,
  '["1 <= word.length <= 10^5","word consists of lowercase English letters from ''a'' to ''j''"]'::jsonb,
  '["Hash Table","String","Bit Manipulation","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function wonderfulSubstrings(word) {\n  // Your code here\n}","python":"def wonderful_substrings(word):\n    pass","java":"class Solution {\n    public long wonderfulSubstrings(String word) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"aba\"","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use bitmask to track parity","Count prefix states with hashmap"]'::jsonb,
  49.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'total-appeal-of-a-string',
  '2262. Total Appeal of A String',
  'total-appeal-of-a-string',
  'hard',
  'The appeal of a string is the number of distinct characters found in the string. For example, the appeal of ''abbca'' is 3 because it has 3 distinct characters: ''a'', ''b'', and ''c''. Given a string s, return the total appeal of all of its substrings.',
  '[{"input":"s = \"abbca\"","output":"28"},{"input":"s = \"code\"","output":"20"}]'::jsonb,
  '["1 <= s.length <= 10^5","s consists of lowercase English letters"]'::jsonb,
  '["Hash Table","String","Dynamic Programming"]'::jsonb,
  'DSA',
  '{"javascript":"function appealSum(s) {\n  // Your code here\n}","python":"def appeal_sum(s):\n    pass","java":"class Solution {\n    public long appealSum(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abbca\"","expectedOutput":"28","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Track contribution of each character","Use last occurrence of each character"]'::jsonb,
  64.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'continuous-subarray-sum',
  '523. Continuous Subarray Sum',
  'continuous-subarray-sum',
  'medium',
  'Given an integer array nums and an integer k, return true if nums has a good subarray or false otherwise. A good subarray is a subarray where: its length is at least two, and the sum of the elements of the subarray is a multiple of k. Note that: A subarray is a contiguous part of the array. An integer x is a multiple of k if there exists an integer n such that x = n * k. 0 is always a multiple of k.',
  '[{"input":"nums = [23,2,4,6,7], k = 6","output":"true"},{"input":"nums = [23,2,6,4,7], k = 6","output":"true"},{"input":"nums = [23,2,6,4,7], k = 13","output":"false"}]'::jsonb,
  '["1 <= nums.length <= 10^5","0 <= nums[i] <= 10^9","0 <= sum(nums[i]) <= 2^31 - 1","1 <= k <= 2^31 - 1"]'::jsonb,
  '["Array","Hash Table","Math","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function checkSubarraySum(nums, k) {\n  // Your code here\n}","python":"def check_subarray_sum(nums, k):\n    pass","java":"class Solution {\n    public boolean checkSubarraySum(int[] nums, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[23,2,4,6,7], 6","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use prefix sum modulo k","Store remainders with indices in hashmap"]'::jsonb,
  29.4,
  '["Facebook","Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'unique-number-of-occurrences',
  '1207. Unique Number of Occurrences',
  'unique-number-of-occurrences',
  'easy',
  'Given an array of integers arr, return true if the number of occurrences of each value in the array is unique or false otherwise.',
  '[{"input":"arr = [1,2,2,1,1,3]","output":"true"},{"input":"arr = [1,2]","output":"false"},{"input":"arr = [-3,0,1,-3,1,1,1,-3,10,0]","output":"true"}]'::jsonb,
  '["1 <= arr.length <= 1000","-1000 <= arr[i] <= 1000"]'::jsonb,
  '["Array","Hash Table"]'::jsonb,
  'DSA',
  '{"javascript":"function uniqueOccurrences(arr) {\n  // Your code here\n}","python":"def unique_occurrences(arr):\n    pass","java":"class Solution {\n    public boolean uniqueOccurrences(int[] arr) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,2,1,1,3]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count frequencies","Check if all counts are unique using set"]'::jsonb,
  75.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-happy-prefix',
  '1392. Longest Happy Prefix',
  'longest-happy-prefix',
  'hard',
  'A string is called a happy prefix if is a non-empty prefix which is also a suffix (excluding itself). Given a string s, return the longest happy prefix of s. Return an empty string '''' if no such prefix exists.',
  '[{"input":"s = \"level\"","output":"\"l\""},{"input":"s = \"ababab\"","output":"\"abab\""}]'::jsonb,
  '["1 <= s.length <= 10^5","s contains only lowercase English letters"]'::jsonb,
  '["String","Rolling Hash","String Matching","Hash Function"]'::jsonb,
  'DSA',
  '{"javascript":"function longestPrefix(s) {\n  // Your code here\n}","python":"def longest_prefix(s):\n    pass","java":"class Solution {\n    public String longestPrefix(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"level\"","expectedOutput":"\"l\"","hidden":false},{"id":"2","input":"\"ababab\"","expectedOutput":"\"abab\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use KMP algorithm or rolling hash","Compare prefix and suffix hashes"]'::jsonb,
  45.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-longest-self-contained-substring',
  '3104. Find Longest Self-Contained Substring',
  'find-longest-self-contained-substring',
  'hard',
  'You are given a string s. A substring of s is considered self-contained if every character that appears in the substring appears the same number of times in s and in that substring. Return the length of the longest self-contained substring of s. If no such substring exists, return 0.',
  '[{"input":"s = \"abba\"","output":"4"},{"input":"s = \"aaccbb\"","output":"6"}]'::jsonb,
  '["1 <= s.length <= 10^5","s consists of lowercase English letters"]'::jsonb,
  '["Hash Table","String","Sliding Window"]'::jsonb,
  'DSA',
  '{"javascript":"function maxLengthBetweenEqualCharacters(s) {\n  // Your code here\n}","python":"def max_length_between_equal_characters(s):\n    pass","java":"class Solution {\n    public int maxLengthBetweenEqualCharacters(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abba\"","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count total character frequencies","Check substrings with matching counts"]'::jsonb,
  38.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'intersection-of-two-arrays',
  '349. Intersection of Two Arrays',
  'intersection-of-two-arrays',
  'easy',
  'Given two integer arrays nums1 and nums2, return an array of their intersection. Each element in the result must be unique and you may return the result in any order.',
  '[{"input":"nums1 = [1,2,2,1], nums2 = [2,2]","output":"[2]"},{"input":"nums1 = [4,9,5], nums2 = [9,4,9,8,4]","output":"[9,4]"}]'::jsonb,
  '["1 <= nums1.length, nums2.length <= 1000","0 <= nums1[i], nums2[i] <= 1000"]'::jsonb,
  '["Array","Hash Table","Two Pointers","Binary Search","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function intersection(nums1, nums2) {\n  // Your code here\n}","python":"def intersection(nums1, nums2):\n    pass","java":"class Solution {\n    public int[] intersection(int[] nums1, int[] nums2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,2,1], [2,2]","expectedOutput":"[2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two hash sets","Or sort and use two pointers"]'::jsonb,
  72.4,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'word-pattern',
  '290. Word Pattern',
  'word-pattern',
  'easy',
  'Given a pattern and a string s, find if s follows the same pattern. Here follow means a full match, such that there is a bijection between a letter in pattern and a non-empty word in s.',
  '[{"input":"pattern = \"abba\", s = \"dog cat cat dog\"","output":"true"},{"input":"pattern = \"abba\", s = \"dog cat cat fish\"","output":"false"},{"input":"pattern = \"aaaa\", s = \"dog cat cat dog\"","output":"false"}]'::jsonb,
  '["1 <= pattern.length <= 300","pattern contains only lower-case English letters","1 <= s.length <= 3000"]'::jsonb,
  '["Hash Table","String"]'::jsonb,
  'DSA',
  '{"javascript":"function wordPattern(pattern, s) {\n  // Your code here\n}","python":"def word_pattern(pattern, s):\n    pass","java":"class Solution {\n    public boolean wordPattern(String pattern, String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abba\", \"dog cat cat dog\"","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two hashmaps for bidirectional mapping","Similar to isomorphic strings"]'::jsonb,
  42.3,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-palindrome',
  '409. Longest Palindrome',
  'longest-palindrome',
  'easy',
  'Given a string s which consists of lowercase or uppercase letters, return the length of the longest palindrome that can be built with those letters. Letters are case sensitive, for example, ''Aa'' is not considered a palindrome here.',
  '[{"input":"s = \"abccccdd\"","output":"7"},{"input":"s = \"a\"","output":"1"}]'::jsonb,
  '["1 <= s.length <= 2000","s consists of lowercase and/or uppercase English letters only"]'::jsonb,
  '["Hash Table","String","Greedy"]'::jsonb,
  'DSA',
  '{"javascript":"function longestPalindrome(s) {\n  // Your code here\n}","python":"def longest_palindrome(s):\n    pass","java":"class Solution {\n    public int longestPalindrome(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abccccdd\"","expectedOutput":"7","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count character frequencies","Use all even counts + at most one odd count"]'::jsonb,
  55.3,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'redundant-connection',
  '684. Redundant Connection',
  'redundant-connection',
  'medium',
  'In this problem, a tree is an undirected graph that is connected and has no cycles. You are given a graph that started as a tree with n nodes labeled from 1 to n, with one additional edge added. The added edge has two different vertices chosen from 1 to n, and was not an edge that already existed. The graph is represented as an array edges of length n where edges[i] = [ai, bi] indicates that there is an edge between nodes ai and bi in the graph. Return an edge that can be removed so that the resulting graph is a tree of n nodes. If there are multiple answers, return the answer that occurs last in the input.',
  '[{"input":"edges = [[1,2],[1,3],[2,3]]","output":"[2,3]"},{"input":"edges = [[1,2],[2,3],[3,4],[1,4],[1,5]]","output":"[1,4]"}]'::jsonb,
  '["n == edges.length","3 <= n <= 1000","edges[i].length == 2","1 <= ai < bi <= edges.length","ai != bi"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Union Find","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function findRedundantConnection(edges) {\n  // Your code here\n}","python":"def find_redundant_connection(edges):\n    pass","java":"class Solution {\n    public int[] findRedundantConnection(int[][] edges) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2],[1,3],[2,3]]","expectedOutput":"[2,3]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use union find to detect cycle","Return edge that creates cycle"]'::jsonb,
  61.2,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-islands-ii',
  '305. Number of Islands II',
  'number-of-islands-ii',
  'medium',
  'You are given an empty 2D binary grid of size m x n. The grid represents a map where 0s represent water and 1s represent land. Initially, all the cells of grid are water cells. We may perform an add land operation which turns the water at position into a land. You are given an array positions where positions[i] = [ri, ci] is the position (ri, ci) at which we should operate the ith operation. Return an array of integers answer where answer[i] is the number of islands after turning the cell (ri, ci) into a land. An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.',
  '[{"input":"m = 3, n = 3, positions = [[0,0],[0,1],[1,2],[2,1]]","output":"[1,1,2,3]"}]'::jsonb,
  '["1 <= m, n, positions.length <= 10^4","1 <= m * n <= 10^4","positions[i].length == 2","0 <= ri < m","0 <= ci < n"]'::jsonb,
  '["Array","Union Find"]'::jsonb,
  'DSA',
  '{"javascript":"function numIslands2(m, n, positions) {\n  // Your code here\n}","python":"def num_islands2(m, n, positions):\n    pass","java":"class Solution {\n    public List<Integer> numIslands2(int m, int n, int[][] positions) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, 3, [[0,0],[0,1],[1,2],[2,1]]","expectedOutput":"[1,1,2,3]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use union find for dynamic connectivity","Track count of components"]'::jsonb,
  45.3,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'most-stones-removed-with-same-row-or-column',
  '947. Most Stones Removed with Same Row or Column',
  'most-stones-removed-with-same-row-or-column',
  'medium',
  'On a 2D plane, we place n stones at some integer coordinate points. Each coordinate point may have at most one stone. A stone can be removed if it shares either the same row or the same column as another stone that has not been removed. Given an array stones of length n where stones[i] = [xi, yi] represents the location of the ith stone, return the largest possible number of stones that can be removed.',
  '[{"input":"stones = [[0,0],[0,1],[1,0],[1,2],[2,1],[2,2]]","output":"5"},{"input":"stones = [[0,0],[0,2],[1,1],[2,0],[2,2]]","output":"3"}]'::jsonb,
  '["1 <= stones.length <= 1000","0 <= xi, yi <= 10^4"]'::jsonb,
  '["Depth-First Search","Union Find","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function removeStones(stones) {\n  // Your code here\n}","python":"def remove_stones(stones):\n    pass","java":"class Solution {\n    public int removeStones(int[][] stones) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,0],[0,1],[1,0],[1,2],[2,1],[2,2]]","expectedOutput":"5","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Connect stones in same row or column","Count connected components using union find"]'::jsonb,
  58.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-consecutive-sequence',
  '128. Longest Consecutive Sequence',
  'longest-consecutive-sequence',
  'medium',
  'Given an unsorted array of integers nums, return the length of the longest consecutive elements sequence. You must write an algorithm that runs in O(n) time.',
  '[{"input":"nums = [100,4,200,1,3,2]","output":"4"},{"input":"nums = [0,3,7,2,5,8,4,6,0,1]","output":"9"}]'::jsonb,
  '["0 <= nums.length <= 10^5","-10^9 <= nums[i] <= 10^9"]'::jsonb,
  '["Array","Hash Table","Union Find"]'::jsonb,
  'DSA',
  '{"javascript":"function longestConsecutive(nums) {\n  // Your code here\n}","python":"def longest_consecutive(nums):\n    pass","java":"class Solution {\n    public int longestConsecutive(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[100,4,200,1,3,2]","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use set for O(1) lookup","Start sequence only from numbers without predecessor"]'::jsonb,
  49.8,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'last-day-where-you-can-still-cross',
  '1970. Last Day Where You Can Still Cross',
  'last-day-where-you-can-still-cross',
  'hard',
  'There is a 1-based binary matrix where 0 represents land and 1 represents water. You are given integers row and col representing the number of rows and columns in the matrix, respectively. Initially on day 0, the entire matrix is land. However, each day a new cell becomes flooded with water. You are given a 1-based 2D array cells, where cells[i] = [ri, ci] represents that on the ith day, the cell on the rith row and cith column (1-based coordinates) will be covered with water (i.e., changed to 1). You want to find the last day that it is possible to walk from the top to the bottom by only walking on land cells. You can start from any cell in the top row and end at any cell in the bottom row. You can only travel between adjacent cells in the four cardinal directions. Return the last day where it is possible to walk from the top to the bottom by only walking on land cells.',
  '[{"input":"row = 2, col = 2, cells = [[1,1],[2,1],[1,2],[2,2]]","output":"2"},{"input":"row = 2, col = 2, cells = [[1,1],[1,2],[2,1],[2,2]]","output":"1"}]'::jsonb,
  '["2 <= row, col <= 2 * 10^4","4 <= row * col <= 2 * 10^4","cells.length == row * col","1 <= ri <= row","1 <= ci <= col"]'::jsonb,
  '["Array","Binary Search","Depth-First Search","Breadth-First Search","Union Find","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function latestDayToCross(row, col, cells) {\n  // Your code here\n}","python":"def latest_day_to_cross(row, col, cells):\n    pass","java":"class Solution {\n    public int latestDayToCross(int row, int col, int[][] cells) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"2, 2, [[1,1],[2,1],[1,2],[2,2]]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Binary search on days","Use union find or BFS to check connectivity"]'::jsonb,
  53.4,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'regions-cut-by-slashes',
  '959. Regions Cut By Slashes',
  'regions-cut-by-slashes',
  'hard',
  'An n x n grid is composed of 1 x 1 squares where each 1 x 1 square consists of a ''/'', ''\'', or blank space '' ''. These characters divide the square into contiguous regions. Given the grid represented as a string array, return the number of regions. Note that backslash characters are escaped, so a ''\'' is represented as ''\\''.',
  '[{"input":"grid = [\" /\",\"/ \"]","output":"2"},{"input":"grid = [\" /\",\"  \"]","output":"1"},{"input":"grid = [\"/\\\\\",\"\\\\/\"]","output":"5"}]'::jsonb,
  '["n == grid.length == grid[i].length","1 <= n <= 30","grid[i][j] is either ''/'', ''\\\\'', or '' ''"]'::jsonb,
  '["Depth-First Search","Breadth-First Search","Union Find","Graph"]'::jsonb,
  'DSA',
  '{"javascript":"function regionsBySlashes(grid) {\n  // Your code here\n}","python":"def regions_by_slashes(grid):\n    pass","java":"class Solution {\n    public int regionsBySlashes(String[] grid) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\" /\",\"/ \"]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Divide each cell into 4 triangles","Use union find to connect adjacent triangles"]'::jsonb,
  72.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'accounts-merge',
  '721. Accounts Merge',
  'accounts-merge',
  'medium',
  'Given a list of accounts where each element accounts[i] is a list of strings, where the first element accounts[i][0] is a name, and the rest of the elements are emails representing emails of the account. Now, we would like to merge these accounts. Two accounts definitely belong to the same person if there is some common email to both accounts. Note that even if two accounts have the same name, they may belong to different people as people could have the same name. A person can have any number of accounts initially, but all of their accounts definitely have the same name. After merging the accounts, return the accounts in the following format: the first element of each account is the name, and the rest of the elements are emails in sorted order.',
  '[{"input":"accounts = [[\"John\",\"johnsmith@mail.com\",\"john_newyork@mail.com\"],[\"John\",\"johnsmith@mail.com\",\"john00@mail.com\"],[\"Mary\",\"mary@mail.com\"],[\"John\",\"johnnybravo@mail.com\"]]","output":"[[\"John\",\"john00@mail.com\",\"john_newyork@mail.com\",\"johnsmith@mail.com\"],[\"Mary\",\"mary@mail.com\"],[\"John\",\"johnnybravo@mail.com\"]]"}]'::jsonb,
  '["1 <= accounts.length <= 1000","2 <= accounts[i].length <= 10","1 <= accounts[i][j].length <= 30"]'::jsonb,
  '["Array","String","Depth-First Search","Breadth-First Search","Union Find"]'::jsonb,
  'DSA',
  '{"javascript":"function accountsMerge(accounts) {\n  // Your code here\n}","python":"def accounts_merge(accounts):\n    pass","java":"class Solution {\n    public List<List<String>> accountsMerge(List<List<String>> accounts) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[\"John\",\"johnsmith@mail.com\",\"john_newyork@mail.com\"],[\"John\",\"johnsmith@mail.com\",\"john00@mail.com\"],[\"Mary\",\"mary@mail.com\"],[\"John\",\"johnnybravo@mail.com\"]]","expectedOutput":"[[\"John\",\"john00@mail.com\",\"john_newyork@mail.com\",\"johnsmith@mail.com\"],[\"Mary\",\"mary@mail.com\"],[\"John\",\"johnnybravo@mail.com\"]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use union find with email as key","Group emails by parent"]'::jsonb,
  58.3,
  '["Facebook","Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimize-malware-spread',
  '924. Minimize Malware Spread',
  'minimize-malware-spread',
  'hard',
  'You are given a network of n nodes represented as an n x n adjacency matrix graph, where the ith node is directly connected to the jth node if graph[i][j] == 1. Some nodes initial are initially infected by malware. Whenever two nodes are directly connected, and at least one of those two nodes is infected by malware, both nodes will be infected by malware. This spread of malware will continue until no more nodes can be infected in this manner. Suppose M(initial) is the final number of nodes infected with malware in the entire network after the spread of malware stops. We will remove exactly one node from initial. Return the node that, if removed, would minimize M(initial). If multiple nodes could be removed to minimize M(initial), return such a node with the smallest index.',
  '[{"input":"graph = [[1,1,0],[1,1,0],[0,0,1]], initial = [0,1]","output":"0"}]'::jsonb,
  '["n == graph.length","n == graph[i].length","2 <= n <= 300","graph[i][j] is 0 or 1","graph[i][j] == graph[j][i]","graph[i][i] == 1","1 <= initial.length <= n","0 <= initial[i] <= n - 1"]'::jsonb,
  '["Array","Depth-First Search","Breadth-First Search","Union Find","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"function minMalwareSpread(graph, initial) {\n  // Your code here\n}","python":"def min_malware_spread(graph, initial):\n    pass","java":"class Solution {\n    public int minMalwareSpread(int[][] graph, int[] initial) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1,0],[1,1,0],[0,0,1]], [0,1]","expectedOutput":"0","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use union find to find connected components","Count infection impact for each node"]'::jsonb,
  42.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'the-skyline-problem',
  '218. The Skyline Problem',
  'the-skyline-problem',
  'hard',
  'A city''s skyline is the outer contour of the silhouette formed by all the buildings in that city when viewed from a distance. Given the locations and heights of all the buildings, return the skyline formed by these buildings collectively. The geometric information of each building is given in the array buildings where buildings[i] = [lefti, righti, heighti]: lefti is the x coordinate of the left edge of the ith building. righti is the x coordinate of the right edge of the ith building. heighti is the height of the ith building. You may assume all buildings are perfect rectangles grounded on an absolutely flat surface at height 0. The skyline should be represented as a list of ''key points'' sorted by their x-coordinate in the form [[x1,y1],[x2,y2],...]. Each key point is the left endpoint of some horizontal segment in the skyline except the last point in the list, which always has a y-coordinate 0 and is used to mark the skyline''s termination where the rightmost building ends. Any ground between the leftmost and rightmost buildings should be part of the skyline''s contour.',
  '[{"input":"buildings = [[2,9,10],[3,7,15],[5,12,12],[15,20,10],[19,24,8]]","output":"[[2,10],[3,15],[7,12],[12,0],[15,10],[20,8],[24,0]]"}]'::jsonb,
  '["1 <= buildings.length <= 10^4","0 <= lefti < righti <= 2^31 - 1","1 <= heighti <= 2^31 - 1"]'::jsonb,
  '["Array","Divide and Conquer","Binary Indexed Tree","Segment Tree","Line Sweep","Heap (Priority Queue)","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"function getSkyline(buildings) {\n  // Your code here\n}","python":"def get_skyline(buildings):\n    pass","java":"class Solution {\n    public List<List<Integer>> getSkyline(int[][] buildings) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[2,9,10],[3,7,15],[5,12,12],[15,20,10],[19,24,8]]","expectedOutput":"[[2,10],[3,15],[7,12],[12,0],[15,10],[20,8],[24,0]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use sweep line algorithm","Process building edges in sorted order"]'::jsonb,
  41.3,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'similar-string-groups',
  '839. Similar String Groups',
  'similar-string-groups',
  'hard',
  'Two strings X and Y are similar if we can swap two letters (in different positions) of X, so that it equals Y. Also two strings X and Y are similar if they are equal. For example, ''tars'' and ''rats'' are similar (swapping at positions 0 and 2), and ''rats'' and ''arts'' are similar, but ''star'' is not similar to ''tars'', ''rats'', or ''arts''. Together, these form two connected groups by similarity: {''tars'', ''rats'', ''arts''} and {''star''}. Notice that ''tars'' and ''arts'' are in the same group even though they are not similar. Formally, each group is such that a word is in the group if and only if it is similar to at least one other word in the group. We are given a list strs of strings where every string in strs is an anagram of every other string in strs. How many groups are there?',
  '[{"input":"strs = [\"tars\",\"rats\",\"arts\",\"star\"]","output":"2"}]'::jsonb,
  '["1 <= strs.length <= 300","1 <= strs[i].length <= 300","strs[i] consists of lowercase letters only"]'::jsonb,
  '["Array","String","Depth-First Search","Breadth-First Search","Union Find"]'::jsonb,
  'DSA',
  '{"javascript":"function numSimilarGroups(strs) {\n  // Your code here\n}","python":"def num_similar_groups(strs):\n    pass","java":"class Solution {\n    public int numSimilarGroups(String[] strs) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"tars\",\"rats\",\"arts\",\"star\"]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Check if two strings are similar","Use union find to group similar strings"]'::jsonb,
  50.7,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'optimize-water-distribution-in-a-village',
  '1168. Optimize Water Distribution in a Village',
  'optimize-water-distribution-in-a-village',
  'hard',
  'There are n houses in a village. We want to supply water for all the houses by building wells and laying pipes. For each house i, we can either build a well inside it directly with cost wells[i - 1] (note the -1 due to 0-indexing), or pipe in water from another well to it. The costs to lay pipes between houses are given by the array pipes, where each pipes[j] = [house1j, house2j, costj] represents the cost to connect house1j and house2j together using a pipe. Connections are bidirectional. Return the minimum total cost to supply water to all houses.',
  '[{"input":"n = 3, wells = [1,2,2], pipes = [[1,2,1],[2,3,1]]","output":"3"}]'::jsonb,
  '["2 <= n <= 10^4","wells.length == n","0 <= wells[i] <= 10^5","1 <= pipes.length <= 10^4","pipes[j].length == 3","1 <= house1j, house2j <= n","0 <= costj <= 10^5"]'::jsonb,
  '["Union Find","Graph","Minimum Spanning Tree"]'::jsonb,
  'DSA',
  '{"javascript":"function minCostToSupplyWater(n, wells, pipes) {\n  // Your code here\n}","python":"def min_cost_to_supply_water(n, wells, pipes):\n    pass","java":"class Solution {\n    public int minCostToSupplyWater(int n, int[] wells, int[][] pipes) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, [1,2,2], [[1,2,1],[2,3,1]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Add virtual node for wells","Use MST with Kruskal algorithm"]'::jsonb,
  65.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'number-of-islands-ii-305',
  '305. Number of Islands II',
  'number-of-islands-ii-305',
  'hard',
  'You are given an empty 2D binary grid of size m x n. The grid represents a map where 0s represent water and 1s represent land. Initially, all the cells of grid are water cells. We may perform an add land operation which turns the water at position into a land. You are given an array positions where positions[i] = [ri, ci] is the position (ri, ci) at which we should operate the ith operation. Return an array of integers answer where answer[i] is the number of islands after turning the cell (ri, ci) into a land. An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.',
  '[{"input":"m = 3, n = 3, positions = [[0,0],[0,1],[1,2],[2,1]]","output":"[1,1,2,3]"}]'::jsonb,
  '["1 <= m, n, positions.length <= 10^4","1 <= m * n <= 10^4","positions[i].length == 2","0 <= ri < m","0 <= ci < n"]'::jsonb,
  '["Array","Union Find"]'::jsonb,
  'DSA',
  '{"javascript":"function numIslands2(m, n, positions) {\n  // Your code here\n}","python":"def num_islands2(m, n, positions):\n    pass","java":"class Solution {\n    public List<Integer> numIslands2(int m, int n, int[][] positions) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3, 3, [[0,0],[0,1],[1,2],[2,1]]","expectedOutput":"[1,1,2,3]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use union find for dynamic connectivity","Maintain island count"]'::jsonb,
  45.3,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'evaluate-division',
  '399. Evaluate Division',
  'evaluate-division',
  'medium',
  'You are given an array of variable pairs equations and an array of real numbers values, where equations[i] = [Ai, Bi] and values[i] represent the equation Ai / Bi = values[i]. Each Ai or Bi is a string that represents a single variable. You are also given some queries, where queries[j] = [Cj, Dj] represents the jth query where you must find the answer for Cj / Dj = ?. Return the answers to all queries. If a single answer cannot be determined, return -1.0. Note: The input is always valid. You may assume that evaluating the queries will not result in division by zero and that there is no contradiction.',
  '[{"input":"equations = [[\"a\",\"b\"],[\"b\",\"c\"]], values = [2.0,3.0], queries = [[\"a\",\"c\"],[\"b\",\"a\"],[\"a\",\"e\"],[\"a\",\"a\"],[\"x\",\"x\"]]","output":"[6.00000,0.50000,-1.00000,1.00000,-1.00000]"}]'::jsonb,
  '["1 <= equations.length <= 20","equations[i].length == 2","1 <= Ai.length, Bi.length <= 5","values.length == equations.length","0.0 < values[i] <= 20.0","1 <= queries.length <= 20","queries[i].length == 2"]'::jsonb,
  '["Array","Depth-First Search","Breadth-First Search","Union Find","Graph","Shortest Path"]'::jsonb,
  'DSA',
  '{"javascript":"function calcEquation(equations, values, queries) {\n  // Your code here\n}","python":"def calc_equation(equations, values, queries):\n    pass","java":"class Solution {\n    public double[] calcEquation(List<List<String>> equations, double[] values, List<List<String>> queries) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[\"a\",\"b\"],[\"b\",\"c\"]], [2.0,3.0], [[\"a\",\"c\"],[\"b\",\"a\"],[\"a\",\"e\"],[\"a\",\"a\"],[\"x\",\"x\"]]","expectedOutput":"[6.00000,0.50000,-1.00000,1.00000,-1.00000]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build graph with weighted edges","Use DFS or union find with weights"]'::jsonb,
  61.8,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'snapshot-array',
  '1146. Snapshot Array',
  'snapshot-array',
  'medium',
  'Implement a SnapshotArray that supports the following interface: SnapshotArray(int length) initializes an array-like data structure with the given length. Initially, each element equals 0. void set(index, val) sets the element at the given index to be equal to val. int snap() takes a snapshot of the array and returns the snap_id: the total number of times we called snap() minus 1. int get(index, snap_id) returns the value at the given index, at the time we took the snapshot with the given snap_id.',
  '[{"input":"[\"SnapshotArray\",\"set\",\"snap\",\"set\",\"get\"]\\n[[3],[0,5],[],[0,6],[0,0]]","output":"[null,null,0,null,5]"}]'::jsonb,
  '["1 <= length <= 5 * 10^4","0 <= index < length","0 <= val <= 10^9","0 <= snap_id < (the total number of times we call snap())","At most 5 * 10^4 calls will be made to set, snap, and get"]'::jsonb,
  '["Array","Hash Table","Binary Search","Design"]'::jsonb,
  'DSA',
  '{"javascript":"class SnapshotArray {\n  constructor(length) {\n  }\n  set(index, val) {\n  }\n  snap() {\n  }\n  get(index, snap_id) {\n  }\n}","python":"class SnapshotArray:\n    def __init__(self, length):\n        pass\n    def set(self, index, val):\n        pass\n    def snap(self):\n        pass\n    def get(self, index, snap_id):\n        pass","java":"class SnapshotArray {\n    public SnapshotArray(int length) {\n    }\n    public void set(int index, int val) {\n    }\n    public int snap() {\n    }\n    public int get(int index, int snap_id) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"SnapshotArray\",\"set\",\"snap\",\"set\",\"get\"], [[3],[0,5],[],[0,6],[0,0]]","expectedOutput":"[null,null,0,null,5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Store history of changes for each index","Use binary search to find value at specific snap_id"]'::jsonb,
  37.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'time-based-key-value-store',
  '981. Time Based Key-Value Store',
  'time-based-key-value-store',
  'medium',
  'Design a time-based key-value data structure that can store multiple values for the same key at different time stamps and retrieve the key''s value at a certain timestamp. Implement the TimeMap class: TimeMap() Initializes the object of the data structure. void set(String key, String value, int timestamp) Stores the key with the value at the given time timestamp. String get(String key, int timestamp) Returns a value such that set was called previously, with timestamp_prev <= timestamp. If there are multiple such values, it returns the value associated with the largest timestamp_prev. If there are no values, it returns ''''.',
  '[{"input":"[\"TimeMap\", \"set\", \"get\", \"get\", \"set\", \"get\", \"get\"]\\n[[], [\"foo\", \"bar\", 1], [\"foo\", 1], [\"foo\", 3], [\"foo\", \"bar2\", 4], [\"foo\", 4], [\"foo\", 5]]","output":"[null, null, \"bar\", \"bar\", null, \"bar2\", \"bar2\"]"}]'::jsonb,
  '["1 <= key.length, value.length <= 100","key and value consist of lowercase English letters and digits","1 <= timestamp <= 10^7","All the timestamps of set are strictly increasing"]'::jsonb,
  '["Hash Table","String","Binary Search","Design"]'::jsonb,
  'DSA',
  '{"javascript":"class TimeMap {\n  constructor() {\n  }\n  set(key, value, timestamp) {\n  }\n  get(key, timestamp) {\n  }\n}","python":"class TimeMap:\n    def __init__(self):\n        pass\n    def set(self, key, value, timestamp):\n        pass\n    def get(self, key, timestamp):\n        pass","java":"class TimeMap {\n    public TimeMap() {\n    }\n    public void set(String key, String value, int timestamp) {\n    }\n    public String get(String key, int timestamp) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"TimeMap\", \"set\", \"get\", \"get\", \"set\", \"get\", \"get\"], [[], [\"foo\", \"bar\", 1], [\"foo\", 1], [\"foo\", 3], [\"foo\", \"bar2\", 4], [\"foo\", 4], [\"foo\", 5]]","expectedOutput":"[null, null, \"bar\", \"bar\", null, \"bar2\", \"bar2\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use hashmap with list of (timestamp, value) pairs","Binary search on timestamps"]'::jsonb,
  54.7,
  '["Google","Amazon","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'lru-cache',
  '146. LRU Cache',
  'lru-cache',
  'medium',
  'Design a data structure that follows the constraints of a Least Recently Used (LRU) cache. Implement the LRUCache class: LRUCache(int capacity) Initialize the LRU cache with positive size capacity. int get(int key) Return the value of the key if the key exists, otherwise return -1. void put(int key, int value) Update the value of the key if the key exists. Otherwise, add the key-value pair to the cache. If the number of keys exceeds the capacity from this operation, evict the least recently used key. The functions get and put must each run in O(1) average time complexity.',
  '[{"input":"[\"LRUCache\", \"put\", \"put\", \"get\", \"put\", \"get\", \"put\", \"get\", \"get\", \"get\"]\\n[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]","output":"[null, null, null, 1, null, -1, null, -1, 3, 4]"}]'::jsonb,
  '["1 <= capacity <= 3000","0 <= key <= 10^4","0 <= value <= 10^5","At most 2 * 10^5 calls will be made to get and put"]'::jsonb,
  '["Hash Table","Linked List","Design","Doubly-Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"class LRUCache {\n  constructor(capacity) {\n  }\n  get(key) {\n  }\n  put(key, value) {\n  }\n}","python":"class LRUCache:\n    def __init__(self, capacity):\n        pass\n    def get(self, key):\n        pass\n    def put(self, key, value):\n        pass","java":"class LRUCache {\n    public LRUCache(int capacity) {\n    }\n    public int get(int key) {\n    }\n    public void put(int key, int value) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"LRUCache\", \"put\", \"put\", \"get\", \"put\", \"get\", \"put\", \"get\", \"get\", \"get\"], [[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]","expectedOutput":"[null, null, null, 1, null, -1, null, -1, 3, 4]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use hashmap + doubly linked list","Move accessed nodes to front"]'::jsonb,
  41.2,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'insert-delete-getrandom-o1',
  '380. Insert Delete GetRandom O(1)',
  'insert-delete-getrandom-o1',
  'medium',
  'Implement the RandomizedSet class: RandomizedSet() Initializes the RandomizedSet object. bool insert(int val) Inserts an item val into the set if not present. Returns true if the item was not present, false otherwise. bool remove(int val) Removes an item val from the set if present. Returns true if the item was present, false otherwise. int getRandom() Returns a random element from the current set of elements (it''s guaranteed that at least one element exists when this method is called). Each element must have the same probability of being returned. You must implement the functions of the class such that each function works in average O(1) time complexity.',
  '[{"input":"[\"RandomizedSet\", \"insert\", \"remove\", \"insert\", \"getRandom\", \"remove\", \"insert\", \"getRandom\"]\\n[[], [1], [2], [2], [], [1], [2], []]","output":"[null, true, false, true, 2, true, false, 2]"}]'::jsonb,
  '["-2^31 <= val <= 2^31 - 1","At most 2 * 10^5 calls will be made to insert, remove, and getRandom","There will be at least one element in the data structure when getRandom is called"]'::jsonb,
  '["Array","Hash Table","Math","Design","Randomized"]'::jsonb,
  'DSA',
  '{"javascript":"class RandomizedSet {\n  constructor() {\n  }\n  insert(val) {\n  }\n  remove(val) {\n  }\n  getRandom() {\n  }\n}","python":"class RandomizedSet:\n    def __init__(self):\n        pass\n    def insert(self, val):\n        pass\n    def remove(self, val):\n        pass\n    def get_random(self):\n        pass","java":"class RandomizedSet {\n    public RandomizedSet() {\n    }\n    public boolean insert(int val) {\n    }\n    public boolean remove(int val) {\n    }\n    public int getRandom() {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"RandomizedSet\", \"insert\", \"remove\", \"insert\", \"getRandom\", \"remove\", \"insert\", \"getRandom\"], [[], [1], [2], [2], [], [1], [2], []]","expectedOutput":"[null, true, false, true, 2, true, false, 2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use array for random access","Use hashmap to store index of each value"]'::jsonb,
  51.8,
  '["Amazon","Facebook","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'min-stack',
  '155. Min Stack',
  'min-stack',
  'medium',
  'Design a stack that supports push, pop, top, and retrieving the minimum element in constant time. Implement the MinStack class: MinStack() initializes the stack object. void push(int val) pushes the element val onto the stack. void pop() removes the element on the top of the stack. int top() gets the top element of the stack. int getMin() retrieves the minimum element in the stack. You must implement a solution with O(1) time complexity for each function.',
  '[{"input":"[\"MinStack\",\"push\",\"push\",\"push\",\"getMin\",\"pop\",\"top\",\"getMin\"]\\n[[],[-2],[0],[-3],[],[],[],[]]","output":"[null,null,null,null,-3,null,0,-2]"}]'::jsonb,
  '["-2^31 <= val <= 2^31 - 1","Methods pop, top and getMin operations will always be called on non-empty stacks","At most 3 * 10^4 calls will be made to push, pop, top, and getMin"]'::jsonb,
  '["Stack","Design"]'::jsonb,
  'DSA',
  '{"javascript":"class MinStack {\n  constructor() {\n  }\n  push(val) {\n  }\n  pop() {\n  }\n  top() {\n  }\n  getMin() {\n  }\n}","python":"class MinStack:\n    def __init__(self):\n        pass\n    def push(self, val):\n        pass\n    def pop(self):\n        pass\n    def top(self):\n        pass\n    def get_min(self):\n        pass","java":"class MinStack {\n    public MinStack() {\n    }\n    public void push(int val) {\n    }\n    public void pop() {\n    }\n    public int top() {\n    }\n    public int getMin() {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MinStack\",\"push\",\"push\",\"push\",\"getMin\",\"pop\",\"top\",\"getMin\"], [[],[-2],[0],[-3],[],[],[],[]]","expectedOutput":"[null,null,null,null,-3,null,0,-2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two stacks: one for values, one for minimums","Or store (value, min) pairs"]'::jsonb,
  53.4,
  '["Amazon","Microsoft","Bloomberg"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'range-module',
  '715. Range Module',
  'range-module',
  'hard',
  'A Range Module is a module that tracks ranges of numbers. Design a data structure to track the ranges represented as half-open intervals and query about them. A half-open interval [left, right) denotes all the real numbers x where left <= x < right. Implement the RangeModule class: RangeModule() Initializes the object of the data structure. void addRange(int left, int right) Adds the half-open interval [left, right), tracking every real number in that interval. Adding an interval that partially overlaps with currently tracked numbers should add any numbers in the interval [left, right) that are not already tracked. void queryRange(int left, int right) Returns true if every real number in the interval [left, right) is currently being tracked, and false otherwise. void removeRange(int left, int right) Stops tracking every real number currently being tracked in the half-open interval [left, right).',
  '[{"input":"[\"RangeModule\", \"addRange\", \"removeRange\", \"queryRange\", \"queryRange\", \"queryRange\"]\\n[[], [10, 20], [14, 16], [10, 14], [13, 15], [16, 17]]","output":"[null, null, null, true, false, true]"}]'::jsonb,
  '["1 <= left < right <= 10^9","At most 10^4 calls will be made to addRange, queryRange, and removeRange"]'::jsonb,
  '["Design","Segment Tree","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"class RangeModule {\n  constructor() {\n  }\n  addRange(left, right) {\n  }\n  queryRange(left, right) {\n  }\n  removeRange(left, right) {\n  }\n}","python":"class RangeModule:\n    def __init__(self):\n        pass\n    def add_range(self, left, right):\n        pass\n    def query_range(self, left, right):\n        pass\n    def remove_range(self, left, right):\n        pass","java":"class RangeModule {\n    public RangeModule() {\n    }\n    public void addRange(int left, int right) {\n    }\n    public boolean queryRange(int left, int right) {\n    }\n    public void removeRange(int left, int right) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"RangeModule\", \"addRange\", \"removeRange\", \"queryRange\", \"queryRange\", \"queryRange\"], [[], [10, 20], [14, 16], [10, 14], [13, 15], [16, 17]]","expectedOutput":"[null, null, null, true, false, true]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use sorted list of disjoint intervals","Merge overlapping intervals when adding"]'::jsonb,
  44.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'shortest-word-distance-ii',
  '244. Shortest Word Distance II',
  'shortest-word-distance-ii',
  'medium',
  'Design a data structure that will be initialized with a string array, and then it should answer queries of the shortest distance between two different strings from the array. Implement the WordDistance class: WordDistance(String[] wordsDict) initializes the object with the strings array wordsDict. int shortest(String word1, String word2) returns the shortest distance between word1 and word2 in the array wordsDict.',
  '[{"input":"[\"WordDistance\", \"shortest\", \"shortest\"]\\n[[[\"practice\", \"makes\", \"perfect\", \"coding\", \"makes\"]], [\"coding\", \"practice\"], [\"makes\", \"coding\"]]","output":"[null, 3, 1]"}]'::jsonb,
  '["1 <= wordsDict.length <= 3 * 10^4","1 <= wordsDict[i].length <= 10","wordsDict[i] consists of lowercase English letters","word1 and word2 are in wordsDict","word1 != word2","At most 5000 calls will be made to shortest"]'::jsonb,
  '["Array","Hash Table","Two Pointers","String","Design"]'::jsonb,
  'DSA',
  '{"javascript":"class WordDistance {\n  constructor(wordsDict) {\n  }\n  shortest(word1, word2) {\n  }\n}","python":"class WordDistance:\n    def __init__(self, words_dict):\n        pass\n    def shortest(self, word1, word2):\n        pass","java":"class WordDistance {\n    public WordDistance(String[] wordsDict) {\n    }\n    public int shortest(String word1, String word2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"WordDistance\", \"shortest\", \"shortest\"], [[[\"practice\", \"makes\", \"perfect\", \"coding\", \"makes\"]], [\"coding\", \"practice\"], [\"makes\", \"coding\"]]","expectedOutput":"[null, 3, 1]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Store indices for each word in hashmap","Use two pointers on sorted index lists"]'::jsonb,
  56.7,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'design-hashset',
  '705. Design HashSet',
  'design-hashset',
  'easy',
  'Design a HashSet without using any built-in hash table libraries. Implement MyHashSet class: void add(key) Inserts the value key into the HashSet. bool contains(key) Returns whether the value key exists in the HashSet or not. void remove(key) Removes the value key in the HashSet. If key does not exist in the HashSet, do nothing.',
  '[{"input":"[\"MyHashSet\", \"add\", \"add\", \"contains\", \"contains\", \"add\", \"contains\", \"remove\", \"contains\"]\\n[[], [1], [2], [1], [3], [2], [2], [2], [2]]","output":"[null, null, null, true, false, null, true, null, false]"}]'::jsonb,
  '["0 <= key <= 10^6","At most 10^4 calls will be made to add, remove, and contains"]'::jsonb,
  '["Array","Hash Table","Linked List","Design","Hash Function"]'::jsonb,
  'DSA',
  '{"javascript":"class MyHashSet {\n  constructor() {\n  }\n  add(key) {\n  }\n  remove(key) {\n  }\n  contains(key) {\n  }\n}","python":"class MyHashSet:\n    def __init__(self):\n        pass\n    def add(self, key):\n        pass\n    def remove(self, key):\n        pass\n    def contains(self, key):\n        pass","java":"class MyHashSet {\n    public MyHashSet() {\n    }\n    public void add(int key) {\n    }\n    public void remove(int key) {\n    }\n    public boolean contains(int key) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MyHashSet\", \"add\", \"add\", \"contains\", \"contains\", \"add\", \"contains\", \"remove\", \"contains\"], [[], [1], [2], [1], [3], [2], [2], [2], [2]]","expectedOutput":"[null, null, null, true, false, null, true, null, false]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use array with buckets","Handle collisions with linked lists"]'::jsonb,
  66.3,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'max-stack',
  '716. Max Stack',
  'max-stack',
  'hard',
  'Design a max stack data structure that supports the stack operations and supports finding the stack''s maximum element. Implement the MaxStack class: MaxStack() Initializes the stack object. void push(int x) Pushes element x onto the stack. int pop() Removes the element on top of the stack and returns it. int top() Gets the element on the top of the stack without removing it. int peekMax() Retrieves the maximum element in the stack without removing it. int popMax() Retrieves the maximum element in the stack and removes it. If there is more than one maximum element, only remove the top-most one. You must come up with a solution that supports O(1) for each top call and O(logn) for each other call.',
  '[{"input":"[\"MaxStack\", \"push\", \"push\", \"push\", \"top\", \"popMax\", \"top\", \"peekMax\", \"pop\", \"top\"]\\n[[], [5], [1], [5], [], [], [], [], [], []]","output":"[null, null, null, null, 5, 5, 1, 5, 1, 5]"}]'::jsonb,
  '["-10^7 <= x <= 10^7","At most 10^5 calls will be made to push, pop, top, peekMax, and popMax","There will be at least one element in the stack when pop, top, peekMax, or popMax is called"]'::jsonb,
  '["Linked List","Stack","Design","Doubly-Linked List","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"class MaxStack {\n  constructor() {\n  }\n  push(x) {\n  }\n  pop() {\n  }\n  top() {\n  }\n  peekMax() {\n  }\n  popMax() {\n  }\n}","python":"class MaxStack:\n    def __init__(self):\n        pass\n    def push(self, x):\n        pass\n    def pop(self):\n        pass\n    def top(self):\n        pass\n    def peek_max(self):\n        pass\n    def pop_max(self):\n        pass","java":"class MaxStack {\n    public MaxStack() {\n    }\n    public void push(int x) {\n    }\n    public int pop() {\n    }\n    public int top() {\n    }\n    public int peekMax() {\n    }\n    public int popMax() {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MaxStack\", \"push\", \"push\", \"push\", \"top\", \"popMax\", \"top\", \"peekMax\", \"pop\", \"top\"], [[], [5], [1], [5], [], [], [], [], [], []]","expectedOutput":"[null, null, null, null, 5, 5, 1, 5, 1, 5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use doubly linked list + TreeMap","Track max values efficiently"]'::jsonb,
  46.8,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'moving-average-from-data-stream',
  '346. Moving Average from Data Stream',
  'moving-average-from-data-stream',
  'easy',
  'Given a stream of integers and a window size, calculate the moving average of all integers in the sliding window. Implement the MovingAverage class: MovingAverage(int size) Initializes the object with the size of the window size. double next(int val) Returns the moving average of the last size values of the stream.',
  '[{"input":"[\"MovingAverage\", \"next\", \"next\", \"next\", \"next\"]\\n[[3], [1], [10], [3], [5]]","output":"[null, 1.0, 5.5, 4.66667, 6.0]"}]'::jsonb,
  '["1 <= size <= 1000","-10^5 <= val <= 10^5","At most 10^4 calls will be made to next"]'::jsonb,
  '["Array","Design","Queue","Data Stream"]'::jsonb,
  'DSA',
  '{"javascript":"class MovingAverage {\n  constructor(size) {\n  }\n  next(val) {\n  }\n}","python":"class MovingAverage:\n    def __init__(self, size):\n        pass\n    def next(self, val):\n        pass","java":"class MovingAverage {\n    public MovingAverage(int size) {\n    }\n    public double next(int val) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MovingAverage\", \"next\", \"next\", \"next\", \"next\"], [[3], [1], [10], [3], [5]]","expectedOutput":"[null, 1.0, 5.5, 4.66667, 6.0]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use queue for sliding window","Maintain running sum"]'::jsonb,
  75.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'two-sum-iii-data-structure-design',
  '170. Two Sum III - Data Structure design',
  'two-sum-iii-data-structure-design',
  'easy',
  'Design a data structure that accepts a stream of integers and checks if it has a pair of integers that sum up to a particular value. Implement the TwoSum class: TwoSum() Initializes the TwoSum object, with an empty array initially. void add(int number) Adds number to the data structure. boolean find(int value) Returns true if there exists any pair of numbers whose sum is equal to value, otherwise, it returns false.',
  '[{"input":"[\"TwoSum\", \"add\", \"add\", \"add\", \"find\", \"find\"]\\n[[], [1], [3], [5], [4], [7]]","output":"[null, null, null, null, true, false]"}]'::jsonb,
  '["-10^5 <= number <= 10^5","-2^31 <= value <= 2^31 - 1","At most 10^4 calls will be made to add and find"]'::jsonb,
  '["Array","Hash Table","Design","Data Stream"]'::jsonb,
  'DSA',
  '{"javascript":"class TwoSum {\n  constructor() {\n  }\n  add(number) {\n  }\n  find(value) {\n  }\n}","python":"class TwoSum:\n    def __init__(self):\n        pass\n    def add(self, number):\n        pass\n    def find(self, value):\n        pass","java":"class TwoSum {\n    public TwoSum() {\n    }\n    public void add(int number) {\n    }\n    public boolean find(int value) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"TwoSum\", \"add\", \"add\", \"add\", \"find\", \"find\"], [[], [1], [3], [5], [4], [7]]","expectedOutput":"[null, null, null, null, true, false]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Store numbers with frequency in hashmap","For find, check if complement exists"]'::jsonb,
  37.4,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'range-sum-query-immutable',
  '303. Range Sum Query - Immutable',
  'range-sum-query-immutable',
  'easy',
  'Given an integer array nums, handle multiple queries of the following type: Calculate the sum of the elements of nums between indices left and right inclusive where left <= right. Implement the NumArray class: NumArray(int[] nums) Initializes the object with the integer array nums. int sumRange(int left, int right) Returns the sum of the elements of nums between indices left and right inclusive (i.e., nums[left] + nums[left + 1] + ... + nums[right]).',
  '[{"input":"[\"NumArray\", \"sumRange\", \"sumRange\", \"sumRange\"]\\n[[[-2, 0, 3, -5, 2, -1]], [0, 2], [2, 5], [0, 5]]","output":"[null, 1, -1, -3]"}]'::jsonb,
  '["1 <= nums.length <= 10^4","-10^5 <= nums[i] <= 10^5","0 <= left <= right < nums.length","At most 10^4 calls will be made to sumRange"]'::jsonb,
  '["Array","Design","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"class NumArray {\n  constructor(nums) {\n  }\n  sumRange(left, right) {\n  }\n}","python":"class NumArray:\n    def __init__(self, nums):\n        pass\n    def sum_range(self, left, right):\n        pass","java":"class NumArray {\n    public NumArray(int[] nums) {\n    }\n    public int sumRange(int left, int right) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"NumArray\", \"sumRange\", \"sumRange\", \"sumRange\"], [[[-2, 0, 3, -5, 2, -1]], [0, 2], [2, 5], [0, 5]]","expectedOutput":"[null, 1, -1, -3]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Precompute prefix sums","Use prefix[right+1] - prefix[left]"]'::jsonb,
  62.8,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'stream-of-characters',
  '1032. Stream of Characters',
  'stream-of-characters',
  'hard',
  'Design an algorithm that accepts a stream of characters and checks if a suffix of these characters is a string of a given array of strings words. For example, if words = [''abc'', ''xyz''] and the stream added the four characters (one by one) ''a'', ''x'', ''y'', and ''z'', your algorithm should detect that the suffix ''xyz'' of the characters ''axyz'' matches ''xyz'' from words. Implement the StreamChecker class: StreamChecker(String[] words) Initializes the object with the strings array words. boolean query(char letter) Accepts a new character from the stream and returns true if any non-empty suffix from the stream forms a word that is in words.',
  '[{"input":"[\"StreamChecker\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\"]\\n[[[\"cd\", \"f\", \"kl\"]], [\"a\"], [\"b\"], [\"c\"], [\"d\"], [\"e\"], [\"f\"], [\"g\"], [\"h\"], [\"i\"], [\"j\"], [\"k\"], [\"l\"]]","output":"[null, false, false, false, true, false, true, false, false, false, false, false, true]"}]'::jsonb,
  '["1 <= words.length <= 2000","1 <= words[i].length <= 200","words[i] consists of lowercase English letters","letter is a lowercase English letter","At most 4 * 10^4 calls will be made to query"]'::jsonb,
  '["Array","String","Design","Trie","Data Stream"]'::jsonb,
  'DSA',
  '{"javascript":"class StreamChecker {\n  constructor(words) {\n  }\n  query(letter) {\n  }\n}","python":"class StreamChecker:\n    def __init__(self, words):\n        pass\n    def query(self, letter):\n        pass","java":"class StreamChecker {\n    public StreamChecker(String[] words) {\n    }\n    public boolean query(char letter) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"StreamChecker\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\", \"query\"], [[[\"cd\", \"f\", \"kl\"]], [\"a\"], [\"b\"], [\"c\"], [\"d\"], [\"e\"], [\"f\"], [\"g\"], [\"h\"], [\"i\"], [\"j\"], [\"k\"], [\"l\"]]","expectedOutput":"[null, false, false, false, true, false, true, false, false, false, false, false, true]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build trie with reversed words","Check stream in reverse order"]'::jsonb,
  51.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'all-o-one-data-structure',
  '432. All O'' one Data Structure',
  'all-o-one-data-structure',
  'hard',
  'Design a data structure to store the strings'' count with the ability to return the strings with minimum and maximum counts. Implement the AllOne class: AllOne() Initializes the object of the data structure. inc(String key) Increments the count of the string key by 1. If key does not exist in the data structure, insert it with count 1. dec(String key) Decrements the count of the string key by 1. If the count of key is 0 after the decrement, remove it from the data structure. It is guaranteed that key exists in the data structure before the decrement. getMaxKey() Returns one of the keys with the maximal count. If no element exists, return an empty string ''''. getMinKey() Returns one of the keys with the minimum count. If no element exists, return an empty string ''''. Note that each function must run in O(1) average time complexity.',
  '[{"input":"[\"AllOne\", \"inc\", \"inc\", \"getMaxKey\", \"getMinKey\", \"inc\", \"getMaxKey\", \"getMinKey\"]\\n[[], [\"hello\"], [\"hello\"], [], [], [\"leet\"], [], []]","output":"[null, null, null, \"hello\", \"hello\", null, \"hello\", \"leet\"]"}]'::jsonb,
  '["1 <= key.length <= 10","key consists of lowercase English letters","It is guaranteed that for each call to dec, key is existing in the data structure","At most 5 * 10^4 calls will be made to inc, dec, getMaxKey, and getMinKey"]'::jsonb,
  '["Hash Table","Linked List","Design","Doubly-Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"class AllOne {\n  constructor() {\n  }\n  inc(key) {\n  }\n  dec(key) {\n  }\n  getMaxKey() {\n  }\n  getMinKey() {\n  }\n}","python":"class AllOne:\n    def __init__(self):\n        pass\n    def inc(self, key):\n        pass\n    def dec(self, key):\n        pass\n    def get_max_key(self):\n        pass\n    def get_min_key(self):\n        pass","java":"class AllOne {\n    public AllOne() {\n    }\n    public void inc(String key) {\n    }\n    public void dec(String key) {\n    }\n    public String getMaxKey() {\n    }\n    public String getMinKey() {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"AllOne\", \"inc\", \"inc\", \"getMaxKey\", \"getMinKey\", \"inc\", \"getMaxKey\", \"getMinKey\"], [[], [\"hello\"], [\"hello\"], [], [], [\"leet\"], [], []]","expectedOutput":"[null, null, null, \"hello\", \"hello\", null, \"hello\", \"leet\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use doubly linked list of buckets","Each bucket stores keys with same count"]'::jsonb,
  38.7,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'finding-mk-average',
  '1825. Finding MK Average',
  'finding-mk-average',
  'hard',
  'You are given two integers, m and k, and a stream of integers. You are tasked to implement a data structure that calculates the MKAverage for the stream. The MKAverage can be calculated using these steps: If the number of the elements in the stream is less than m you should consider the MKAverage to be -1. Otherwise, copy the last m elements of the stream to a separate container. Remove the smallest k elements and the largest k elements from the container. Calculate the average value for the rest of the elements rounded down to the nearest integer. Implement the MKAverage class: MKAverage(int m, int k) Initializes the MKAverage object with an empty stream and the two integers m and k. void addElement(int num) Inserts a new element num into the stream. int calculateMKAverage() Calculates and returns the MKAverage for the current stream rounded down to the nearest integer.',
  '[{"input":"[\"MKAverage\", \"addElement\", \"addElement\", \"calculateMKAverage\", \"addElement\", \"calculateMKAverage\", \"addElement\", \"addElement\", \"addElement\", \"calculateMKAverage\"]\\n[[3, 1], [3], [1], [], [10], [], [5], [5], [5], []]","output":"[null, null, null, -1, null, 3, null, null, null, 5]"}]'::jsonb,
  '["3 <= m <= 10^5","1 <= k*2 < m","1 <= num <= 10^5","At most 10^5 calls will be made to addElement and calculateMKAverage"]'::jsonb,
  '["Design","Queue","Heap (Priority Queue)","Data Stream","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"class MKAverage {\n  constructor(m, k) {\n  }\n  addElement(num) {\n  }\n  calculateMKAverage() {\n  }\n}","python":"class MKAverage:\n    def __init__(self, m, k):\n        pass\n    def add_element(self, num):\n        pass\n    def calculate_mk_average(self):\n        pass","java":"class MKAverage {\n    public MKAverage(int m, int k) {\n    }\n    public void addElement(int num) {\n    }\n    public int calculateMKAverage() {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"MKAverage\", \"addElement\", \"addElement\", \"calculateMKAverage\", \"addElement\", \"calculateMKAverage\", \"addElement\", \"addElement\", \"addElement\", \"calculateMKAverage\"], [[3, 1], [3], [1], [], [10], [], [5], [5], [5], []]","expectedOutput":"[null, null, null, -1, null, 3, null, null, null, 5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use three multisets for smallest k, middle, and largest k","Maintain sliding window with queue"]'::jsonb,
  35.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'lfu-cache',
  '460. LFU Cache',
  'lfu-cache',
  'hard',
  'Design and implement a data structure for a Least Frequently Used (LFU) cache. Implement the LFUCache class: LFUCache(int capacity) Initializes the object with the capacity of the data structure. int get(int key) Gets the value of the key if the key exists in the cache. Otherwise, returns -1. void put(int key, int value) Update the value of the key if present, or inserts the key if not already present. When the cache reaches its capacity, it should invalidate and remove the least frequently used key before inserting a new item. For this problem, when there is a tie (i.e., two or more keys with the same frequency), the least recently used key would be invalidated. To determine the least frequently used key, a use counter is maintained for each key in the cache. The key with the smallest use counter is the least frequently used key. When a key is first inserted into the cache, its use counter is set to 1 (due to the put operation). The use counter for a key in the cache is incremented either a get or put operation is called on it. The functions get and put must each run in O(1) average time complexity.',
  '[{"input":"[\"LFUCache\", \"put\", \"put\", \"get\", \"put\", \"get\", \"get\", \"put\", \"get\", \"get\", \"get\"]\\n[[2], [1, 1], [2, 2], [1], [3, 3], [2], [3], [4, 4], [1], [3], [4]]","output":"[null, null, null, 1, null, -1, 3, null, -1, 3, 4]"}]'::jsonb,
  '["1 <= capacity <= 10^4","0 <= key <= 10^5","0 <= value <= 10^9","At most 2 * 10^5 calls will be made to get and put"]'::jsonb,
  '["Hash Table","Linked List","Design","Doubly-Linked List"]'::jsonb,
  'DSA',
  '{"javascript":"class LFUCache {\n  constructor(capacity) {\n  }\n  get(key) {\n  }\n  put(key, value) {\n  }\n}","python":"class LFUCache:\n    def __init__(self, capacity):\n        pass\n    def get(self, key):\n        pass\n    def put(self, key, value):\n        pass","java":"class LFUCache {\n    public LFUCache(int capacity) {\n    }\n    public int get(int key) {\n    }\n    public void put(int key, int value) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"LFUCache\", \"put\", \"put\", \"get\", \"put\", \"get\", \"get\", \"put\", \"get\", \"get\", \"get\"], [[2], [1, 1], [2, 2], [1], [3, 3], [2], [3], [4, 4], [1], [3], [4]]","expectedOutput":"[null, null, null, 1, null, -1, 3, null, -1, 3, 4]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use two hashmaps: key->value and key->frequency","Maintain frequency buckets with doubly linked lists"]'::jsonb,
  41.3,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-the-difference',
  '389. Find the Difference',
  'find-the-difference',
  'easy',
  'You are given two strings s and t. String t is generated by random shuffling string s and then add one more letter at a random position. Return the letter that was added to t.',
  '[{"input":"s = \"abcd\", t = \"abcde\"","output":"\"e\""},{"input":"s = \"\", t = \"y\"","output":"\"y\""}]'::jsonb,
  '["0 <= s.length <= 1000","t.length == s.length + 1","s and t consist of lowercase English letters"]'::jsonb,
  '["Hash Table","String","Bit Manipulation","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function findTheDifference(s, t) {\n  // Your code here\n}","python":"def find_the_difference(s, t):\n    pass","java":"class Solution {\n    public char findTheDifference(String s, String t) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"abcd\", \"abcde\"","expectedOutput":"\"e\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use XOR to find the difference","XOR all characters in both strings"]'::jsonb,
  60.3,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'complement-of-base-10-integer',
  '1009. Complement of Base 10 Integer',
  'complement-of-base-10-integer',
  'easy',
  'The complement of an integer is the integer you get when you flip all the 0''s to 1''s and all the 1''s to 0''s in its binary representation. For example, The integer 5 is ''101'' in binary and its complement is ''010'' which is the integer 2. Given an integer n, return its complement.',
  '[{"input":"n = 5","output":"2"},{"input":"n = 7","output":"0"},{"input":"n = 10","output":"5"}]'::jsonb,
  '["0 <= n < 10^9"]'::jsonb,
  '["Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function bitwiseComplement(n) {\n  // Your code here\n}","python":"def bitwise_complement(n):\n    pass","java":"class Solution {\n    public int bitwiseComplement(int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"5","expectedOutput":"2","hidden":false},{"id":"2","input":"7","expectedOutput":"0","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Create a bitmask with all 1s of same length","XOR with the bitmask"]'::jsonb,
  61.8,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'flipping-an-image',
  '832. Flipping an Image',
  'flipping-an-image',
  'easy',
  'Given an n x n binary matrix image, flip the image horizontally, then invert it, and return the resulting image. To flip an image horizontally means that each row of the image is reversed. For example, flipping [1,1,0] horizontally results in [0,1,1]. To invert an image means that each 0 is replaced by 1, and each 1 is replaced by 0. For example, inverting [0,1,1] results in [1,0,0].',
  '[{"input":"image = [[1,1,0],[1,0,1],[0,0,0]]","output":"[[1,0,0],[0,1,0],[1,1,1]]"},{"input":"image = [[1,1,0,0],[1,0,0,1],[0,1,1,1],[1,0,1,0]]","output":"[[1,1,0,0],[0,1,1,0],[0,0,0,1],[1,0,1,0]]"}]'::jsonb,
  '["n == image.length","n == image[i].length","1 <= n <= 20","images[i][j] is either 0 or 1"]'::jsonb,
  '["Array","Two Pointers","Matrix","Simulation"]'::jsonb,
  'DSA',
  '{"javascript":"function flipAndInvertImage(image) {\n  // Your code here\n}","python":"def flip_and_invert_image(image):\n    pass","java":"class Solution {\n    public int[][] flipAndInvertImage(int[][] image) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1,0],[1,0,1],[0,0,0]]","expectedOutput":"[[1,0,0],[0,1,0],[1,1,1]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Reverse each row","XOR with 1 to invert bits"]'::jsonb,
  80.7,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'single-number',
  '136. Single Number',
  'single-number',
  'easy',
  'Given a non-empty array of integers nums, every element appears twice except for one. Find that single one. You must implement a solution with a linear runtime complexity and use only constant extra space.',
  '[{"input":"nums = [2,2,1]","output":"1"},{"input":"nums = [4,1,2,1,2]","output":"4"},{"input":"nums = [1]","output":"1"}]'::jsonb,
  '["1 <= nums.length <= 3 * 10^4","-3 * 10^4 <= nums[i] <= 3 * 10^4","Each element in the array appears twice except for one element which appears only once"]'::jsonb,
  '["Array","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function singleNumber(nums) {\n  // Your code here\n}","python":"def single_number(nums):\n    pass","java":"class Solution {\n    public int singleNumber(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,2,1]","expectedOutput":"1","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["XOR all numbers","Duplicate numbers cancel out with XOR"]'::jsonb,
  70.8,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'single-number-ii',
  '137. Single Number II',
  'single-number-ii',
  'medium',
  'Given an integer array nums where every element appears three times except for one, which appears exactly once. Find the single element and return it. You must implement a solution with a linear runtime complexity and use only constant extra space.',
  '[{"input":"nums = [2,2,3,2]","output":"3"},{"input":"nums = [0,1,0,1,0,1,99]","output":"99"}]'::jsonb,
  '["1 <= nums.length <= 3 * 10^4","-2^31 <= nums[i] <= 2^31 - 1","Each element in nums appears exactly three times except for one element which appears once"]'::jsonb,
  '["Array","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function singleNumber(nums) {\n  // Your code here\n}","python":"def single_number(nums):\n    pass","java":"class Solution {\n    public int singleNumber(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,2,3,2]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Count bits at each position","Mod 3 to find single number bits"]'::jsonb,
  59.3,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'encode-and-decode-strings',
  '271. Encode and Decode Strings',
  'encode-and-decode-strings',
  'medium',
  'Design an algorithm to encode a list of strings to a string. The encoded string is then sent over the network and is decoded back to the original list of strings. Implement the encode and decode methods. Note: The string may contain any possible characters out of 256 valid ascii characters. Your algorithm should be generalized enough to work on any possible characters. Do not use class member/global/static variables to store states. Your encode and decode algorithms should be stateless. Do not rely on any library method such as eval or serialize methods. You should implement your own encode/decode algorithm.',
  '[{"input":"strs = [\"Hello\",\"World\"]","output":"[\"Hello\",\"World\"]"},{"input":"strs = [\"\"]","output":"[\"\"]"}]'::jsonb,
  '["1 <= strs.length <= 200","0 <= strs[i].length <= 200","strs[i] contains any possible characters out of 256 valid ASCII characters"]'::jsonb,
  '["Array","String","Design"]'::jsonb,
  'DSA',
  '{"javascript":"function encode(strs) {\n  // Your code here\n}\n\nfunction decode(s) {\n  // Your code here\n}","python":"def encode(strs):\n    pass\n\ndef decode(s):\n    pass","java":"class Codec {\n    public String encode(List<String> strs) {\n    }\n    public List<String> decode(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"Hello\",\"World\"]","expectedOutput":"[\"Hello\",\"World\"]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use length prefix for each string","Format: length#string for each entry"]'::jsonb,
  38.7,
  '["Google","Facebook","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'sum-of-all-subset-xor-totals',
  '1863. Sum of All Subset XOR Totals',
  'sum-of-all-subset-xor-totals',
  'easy',
  'The XOR total of an array is defined as the bitwise XOR of all its elements, or 0 if the array is empty. For example, the XOR total of the array [2,5,6] is 2 XOR 5 XOR 6 = 1. Given an array nums, return the sum of all XOR totals for every subset of nums. Note: Subsets with the same elements should be counted multiple times. An array a is a subset of an array b if a can be obtained from b by deleting some (possibly zero) elements of b.',
  '[{"input":"nums = [1,3]","output":"6"},{"input":"nums = [5,1,6]","output":"28"},{"input":"nums = [3,4,5,6,7,8]","output":"480"}]'::jsonb,
  '["1 <= nums.length <= 12","1 <= nums[i] <= 20"]'::jsonb,
  '["Array","Math","Backtracking","Bit Manipulation","Combinatorics"]'::jsonb,
  'DSA',
  '{"javascript":"function subsetXORSum(nums) {\n  // Your code here\n}","python":"def subset_xor_sum(nums):\n    pass","java":"class Solution {\n    public int subsetXORSum(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,3]","expectedOutput":"6","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use recursion to generate all subsets","OR all numbers and multiply by 2^(n-1)"]'::jsonb,
  81.7,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-the-k-th-lucky-number',
  '1922. Find The K-th Lucky Number',
  'find-the-k-th-lucky-number',
  'medium',
  'We define a lucky number as a positive integer that contains only the digits 4 and 7. Given an integer k, return the kth lucky number. Note: The first lucky number is 4.',
  '[{"input":"k = 4","output":"47"},{"input":"k = 10","output":"477"}]'::jsonb,
  '["1 <= k <= 10^9"]'::jsonb,
  '["Math","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function kthLuckyNumber(k) {\n  // Your code here\n}","python":"def kth_lucky_number(k):\n    pass","java":"class Solution {\n    public String kthLuckyNumber(int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"4","expectedOutput":"\"47\"","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Think of it as binary representation","Map 0->4 and 1->7"]'::jsonb,
  65.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-number-of-k-consecutive-bit-flips',
  '995. Minimum Number of K Consecutive Bit Flips',
  'minimum-number-of-k-consecutive-bit-flips',
  'hard',
  'You are given a binary array nums and an integer k. A k-bit flip is choosing a subarray of length k from nums and simultaneously changing every 0 in the subarray to 1, and every 1 in the subarray to 0. Return the minimum number of k-bit flips required so that there is no 0 in the array. If it is not possible, return -1. A subarray is a contiguous part of an array.',
  '[{"input":"nums = [0,1,0], k = 1","output":"2"},{"input":"nums = [1,1,0], k = 2","output":"-1"},{"input":"nums = [0,0,0,1,0,1,1,0], k = 3","output":"3"}]'::jsonb,
  '["1 <= nums.length <= 10^5","1 <= k <= nums.length"]'::jsonb,
  '["Array","Bit Manipulation","Prefix Sum","Sliding Window"]'::jsonb,
  'DSA',
  '{"javascript":"function minKBitFlips(nums, k) {\n  // Your code here\n}","python":"def min_k_bit_flips(nums, k):\n    pass","java":"class Solution {\n    public int minKBitFlips(int[] nums, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[0,1,0], 1","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use greedy approach from left to right","Track flip count with sliding window"]'::jsonb,
  51.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'find-the-longest-substring-containing-vowels-in-even-counts',
  '1371. Find the Longest Substring Containing Vowels in Even Counts',
  'find-the-longest-substring-containing-vowels-in-even-counts',
  'medium',
  'Given the string s, return the size of the longest substring containing each vowel an even number of times. That is, ''a'', ''e'', ''i'', ''o'', and ''u'' must appear an even number of times.',
  '[{"input":"s = \"eleetminicoworoep\"","output":"13"},{"input":"s = \"leetcodeisgreat\"","output":"5"},{"input":"s = \"bcbcbc\"","output":"6"}]'::jsonb,
  '["1 <= s.length <= 5 * 10^5","s contains only lowercase English letters"]'::jsonb,
  '["Hash Table","String","Bit Manipulation","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function findTheLongestSubstring(s) {\n  // Your code here\n}","python":"def find_the_longest_substring(s):\n    pass","java":"class Solution {\n    public int findTheLongestSubstring(String s) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"\"eleetminicoworoep\"","expectedOutput":"13","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use bitmask to track vowel parity","Store first occurrence of each state"]'::jsonb,
  64.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'count-triplets-that-can-form-two-arrays-of-equal-xor',
  '1442. Count Triplets That Can Form Two Arrays of Equal XOR',
  'count-triplets-that-can-form-two-arrays-of-equal-xor',
  'medium',
  'Given an array of integers arr. We want to select three indices i, j and k where (0 <= i < j <= k < arr.length). Let''s define a and b as follows: a = arr[i] ^ arr[i + 1] ^ ... ^ arr[j - 1] and b = arr[j] ^ arr[j + 1] ^ ... ^ arr[k]. Note that ^ denotes the bitwise-xor operation. Return the number of triplets (i, j and k) where a == b.',
  '[{"input":"arr = [2,3,1,6,7]","output":"4"},{"input":"arr = [1,1,1,1,1]","output":"10"}]'::jsonb,
  '["1 <= arr.length <= 300","1 <= arr[i] <= 10^8"]'::jsonb,
  '["Array","Hash Table","Math","Bit Manipulation","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function countTriplets(arr) {\n  // Your code here\n}","python":"def count_triplets(arr):\n    pass","java":"class Solution {\n    public int countTriplets(int[] arr) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,3,1,6,7]","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["If a == b, then a XOR b = 0","Use prefix XOR to find subarrays with XOR 0"]'::jsonb,
  74.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-subarray-with-maximum-bitwise-and',
  '2419. Longest Subarray With Maximum Bitwise AND',
  'longest-subarray-with-maximum-bitwise-and',
  'medium',
  'You are given an integer array nums of size n. Consider a non-empty subarray from nums that has the maximum possible bitwise AND. In other words, let k be the maximum value of the bitwise AND of any subarray of nums. Then, only subarrays with a bitwise AND equal to k should be considered. Return the length of the longest such subarray. The bitwise AND of an array is the bitwise AND of all the numbers in it. A subarray is a contiguous sequence of elements within an array.',
  '[{"input":"nums = [1,2,3,3,2,2]","output":"2"},{"input":"nums = [1,2,3,4]","output":"1"}]'::jsonb,
  '["1 <= nums.length <= 10^5","1 <= nums[i] <= 10^6"]'::jsonb,
  '["Array","Bit Manipulation","Brainteaser"]'::jsonb,
  'DSA',
  '{"javascript":"function longestSubarray(nums) {\n  // Your code here\n}","python":"def longest_subarray(nums):\n    pass","java":"class Solution {\n    public int longestSubarray(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[1,2,3,3,2,2]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Maximum AND equals the maximum element","Find longest consecutive sequence of max element"]'::jsonb,
  48.3,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-one-bit-operations-to-make-integers-zero',
  '1611. Minimum One Bit Operations to Make Integers Zero',
  'minimum-one-bit-operations-to-make-integers-zero',
  'hard',
  'Given an integer n, you must transform it into 0 using the following operations any number of times: Change the rightmost (0th) bit in the binary representation of n. Change the ith bit in the binary representation of n if the (i-1)th bit is set to 1 and the (i-2)th through 0th bits are set to 0. Return the minimum number of operations to transform n into 0.',
  '[{"input":"n = 3","output":"2"},{"input":"n = 6","output":"4"}]'::jsonb,
  '["0 <= n <= 10^9"]'::jsonb,
  '["Dynamic Programming","Bit Manipulation","Memoization"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumOneBitOperations(n) {\n  // Your code here\n}","python":"def minimum_one_bit_operations(n):\n    pass","java":"class Solution {\n    public int minimumOneBitOperations(int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"3","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Related to Gray code","Use XOR property with right shift"]'::jsonb,
  64.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'triples-with-bitwise-and-equal-to-zero',
  '982. Triples with Bitwise AND Equal To Zero',
  'triples-with-bitwise-and-equal-to-zero',
  'hard',
  'Given an integer array nums, return the number of AND triples. An AND triple is a triple of indices (i, j, k) such that: 0 <= i < nums.length, 0 <= j < nums.length, 0 <= k < nums.length, and nums[i] & nums[j] & nums[k] == 0, where & represents the bitwise-AND operator.',
  '[{"input":"nums = [2,1,3]","output":"12"}]'::jsonb,
  '["1 <= nums.length <= 1000","0 <= nums[i] < 2^16"]'::jsonb,
  '["Array","Hash Table","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function countTriplets(nums) {\n  // Your code here\n}","python":"def count_triplets(nums):\n    pass","java":"class Solution {\n    public int countTriplets(int[] nums) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,1,3]","expectedOutput":"12","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Precompute pairs with their AND","Use hashmap to count pair ANDs"]'::jsonb,
  58.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'power-of-two',
  '231. Power of Two',
  'power-of-two',
  'easy',
  'Given an integer n, return true if it is a power of two. Otherwise, return false. An integer n is a power of two, if there exists an integer x such that n == 2^x.',
  '[{"input":"n = 1","output":"true"},{"input":"n = 16","output":"true"},{"input":"n = 3","output":"false"}]'::jsonb,
  '["-2^31 <= n <= 2^31 - 1"]'::jsonb,
  '["Math","Bit Manipulation","Recursion"]'::jsonb,
  'DSA',
  '{"javascript":"function isPowerOfTwo(n) {\n  // Your code here\n}","python":"def is_power_of_two(n):\n    pass","java":"class Solution {\n    public boolean isPowerOfTwo(int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"1","expectedOutput":"true","hidden":false},{"id":"2","input":"16","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Powers of 2 have only one bit set","Use n & (n-1) == 0"]'::jsonb,
  46.7,
  '["Amazon","Microsoft","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-bits',
  '190. Reverse Bits',
  'reverse-bits',
  'easy',
  'Reverse bits of a given 32 bits unsigned integer. Note: Note that in some languages, such as Java, there is no unsigned integer type. In this case, both input and output will be given as a signed integer type. They should not affect your implementation, as the integer''s internal binary representation is the same, whether it is signed or unsigned. In Java, the compiler represents the signed integers using 2''s complement notation.',
  '[{"input":"n = 00000010100101000001111010011100","output":"964176192"},{"input":"n = 11111111111111111111111111111101","output":"3221225471"}]'::jsonb,
  '["The input must be a binary string of length 32"]'::jsonb,
  '["Divide and Conquer","Bit Manipulation"]'::jsonb,
  'DSA',
  '{"javascript":"function reverseBits(n) {\n  // Your code here\n}","python":"def reverse_bits(n):\n    pass","java":"class Solution {\n    public int reverseBits(int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"43261596","expectedOutput":"964176192","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Process bit by bit","Shift result left and add current bit"]'::jsonb,
  53.8,
  '["Amazon","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'check-if-it-is-a-straight-line',
  '1232. Check If It Is a Straight Line',
  'check-if-it-is-a-straight-line',
  'easy',
  'You are given an array coordinates, coordinates[i] = [x, y], where [x, y] represents the coordinate of a point. Check if these points make a straight line in the XY plane.',
  '[{"input":"coordinates = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]]","output":"true"},{"input":"coordinates = [[1,1],[2,2],[3,4],[4,5],[5,6],[7,7]]","output":"false"}]'::jsonb,
  '["2 <= coordinates.length <= 1000","coordinates[i].length == 2","-10^4 <= coordinates[i][0], coordinates[i][1] <= 10^4","coordinates contains no duplicate point"]'::jsonb,
  '["Array","Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function checkStraightLine(coordinates) {\n  // Your code here\n}","python":"def check_straight_line(coordinates):\n    pass","java":"class Solution {\n    public boolean checkStraightLine(int[][] coordinates) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Check if all points have same slope","Use cross product to avoid division"]'::jsonb,
  43.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-cuts-to-divide-a-circle',
  '2481. Minimum Cuts to Divide a Circle',
  'minimum-cuts-to-divide-a-circle',
  'easy',
  'A valid cut in a circle can be: A cut that is represented by a straight line that touches two points on the edge of the circle and passes through its center, or A cut that is represented by a straight line that touches one point on the edge of the circle and its center. Some valid and invalid cuts are shown in the figures below. Given the integer n, return the minimum number of cuts needed to divide a circle into n equal slices.',
  '[{"input":"n = 4","output":"2"},{"input":"n = 3","output":"3"}]'::jsonb,
  '["1 <= n <= 100"]'::jsonb,
  '["Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function numberOfCuts(n) {\n  // Your code here\n}","python":"def number_of_cuts(n):\n    pass","java":"class Solution {\n    public int numberOfCuts(int n) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"4","expectedOutput":"2","hidden":false},{"id":"2","input":"3","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["If n is 1, need 0 cuts","If n is even, need n/2 cuts, otherwise n cuts"]'::jsonb,
  54.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'rectangle-overlap',
  '836. Rectangle Overlap',
  'rectangle-overlap',
  'easy',
  'An axis-aligned rectangle is represented as a list [x1, y1, x2, y2], where (x1, y1) is the coordinate of its bottom-left corner, and (x2, y2) is the coordinate of its top-right corner. Its top and bottom edges are parallel to the X-axis, and its left and right edges are parallel to the Y-axis. Two rectangles overlap if the area of their intersection is positive. To be clear, two rectangles that only touch at the corner or edges do not overlap. Given two axis-aligned rectangles rec1 and rec2, return true if they overlap, otherwise return false.',
  '[{"input":"rec1 = [0,0,2,2], rec2 = [1,1,3,3]","output":"true"},{"input":"rec1 = [0,0,1,1], rec2 = [1,0,2,1]","output":"false"}]'::jsonb,
  '["rec1.length == 4","rec2.length == 4","-10^9 <= rec1[i], rec2[i] <= 10^9","rec1 and rec2 represent valid rectangles with non-zero area"]'::jsonb,
  '["Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function isRectangleOverlap(rec1, rec2) {\n  // Your code here\n}","python":"def is_rectangle_overlap(rec1, rec2):\n    pass","java":"class Solution {\n    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[0,0,2,2], [1,1,3,3]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Check if rectangles do NOT overlap","No overlap if one is left/right/above/below the other"]'::jsonb,
  44.7,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-time-visiting-all-points',
  '1266. Minimum Time Visiting All Points',
  'minimum-time-visiting-all-points',
  'easy',
  'On a 2D plane, there are n points with integer coordinates points[i] = [xi, yi]. Return the minimum time in seconds to visit all the points in the order given by points. You can move according to these rules: In 1 second, you can either: move vertically by one unit, move horizontally by one unit, or move diagonally sqrt(2) units (in other words, move one unit vertically then one unit horizontally in 1 second). You have to visit the points in the same order as they appear in the array. You are allowed to pass through points that appear later in the order, but these do not count as visits.',
  '[{"input":"points = [[1,1],[3,4],[-1,0]]","output":"7"},{"input":"points = [[3,2],[-2,2]]","output":"5"}]'::jsonb,
  '["points.length == n","1 <= n <= 100","points[i].length == 2","-1000 <= points[i][0], points[i][1] <= 1000"]'::jsonb,
  '["Array","Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function minTimeToVisitAllPoints(points) {\n  // Your code here\n}","python":"def min_time_to_visit_all_points(points):\n    pass","java":"class Solution {\n    public int minTimeToVisitAllPoints(int[][] points) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1],[3,4],[-1,0]]","expectedOutput":"7","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Time between two points is max(|x2-x1|, |y2-y1|)","Sum up time for each consecutive pair"]'::jsonb,
  79.3,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'reverse-integer',
  '7. Reverse Integer',
  'reverse-integer',
  'medium',
  'Given a signed 32-bit integer x, return x with its digits reversed. If reversing x causes the value to go outside the signed 32-bit integer range [-2^31, 2^31 - 1], then return 0. Assume the environment does not allow you to store 64-bit integers (signed or unsigned).',
  '[{"input":"x = 123","output":"321"},{"input":"x = -123","output":"-321"},{"input":"x = 120","output":"21"}]'::jsonb,
  '["-2^31 <= x <= 2^31 - 1"]'::jsonb,
  '["Math"]'::jsonb,
  'DSA',
  '{"javascript":"function reverse(x) {\n  // Your code here\n}","python":"def reverse(x):\n    pass","java":"class Solution {\n    public int reverse(int x) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"123","expectedOutput":"321","hidden":false},{"id":"2","input":"-123","expectedOutput":"-321","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Extract digits one by one","Check for overflow before adding digit"]'::jsonb,
  27.8,
  '["Amazon","Microsoft","Apple"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'valid-square',
  '593. Valid Square',
  'valid-square',
  'medium',
  'Given the coordinates of four points in 2D space p1, p2, p3 and p4, return true if the four points construct a square. The coordinate of a point pi is represented as [xi, yi]. The input is not given in any order. A valid square has four equal sides with positive length and four equal angles (90-degree angles).',
  '[{"input":"p1 = [0,0], p2 = [1,1], p3 = [1,0], p4 = [0,1]","output":"true"},{"input":"p1 = [0,0], p2 = [1,1], p3 = [1,0], p4 = [0,12]","output":"false"}]'::jsonb,
  '["p1.length == p2.length == p3.length == p4.length == 2","-10^4 <= xi, yi <= 10^4"]'::jsonb,
  '["Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function validSquare(p1, p2, p3, p4) {\n  // Your code here\n}","python":"def valid_square(p1, p2, p3, p4):\n    pass","java":"class Solution {\n    public boolean validSquare(int[] p1, int[] p2, int[] p3, int[] p4) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[0,0], [1,1], [1,0], [0,1]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Calculate all 6 distances","Should have 4 equal sides and 2 equal diagonals"]'::jsonb,
  44.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'rectangle-area',
  '223. Rectangle Area',
  'rectangle-area',
  'medium',
  'Given the coordinates of two rectilinear rectangles in a 2D plane, return the total area covered by the two rectangles. The first rectangle is defined by its bottom-left corner (ax1, ay1) and its top-right corner (ax2, ay2). The second rectangle is defined by its bottom-left corner (bx1, by1) and its top-right corner (bx2, by2).',
  '[{"input":"ax1 = -3, ay1 = 0, ax2 = 3, ay2 = 4, bx1 = 0, by1 = -1, bx2 = 9, by2 = 2","output":"45"},{"input":"ax1 = -2, ay1 = -2, ax2 = 2, ay2 = 2, bx1 = -2, by1 = -2, bx2 = 2, by2 = 2","output":"16"}]'::jsonb,
  '["-10^4 <= ax1 <= ax2 <= 10^4","-10^4 <= ay1 <= ay2 <= 10^4","-10^4 <= bx1 <= bx2 <= 10^4","-10^4 <= by1 <= by2 <= 10^4"]'::jsonb,
  '["Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function computeArea(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2) {\n  // Your code here\n}","python":"def compute_area(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2):\n    pass","java":"class Solution {\n    public int computeArea(int ax1, int ay1, int ax2, int ay2, int bx1, int by1, int bx2, int by2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"-3, 0, 3, 4, 0, -1, 9, 2","expectedOutput":"45","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Calculate both areas","Subtract overlap area if rectangles intersect"]'::jsonb,
  42.3,
  '["Amazon","Microsoft"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-area-rectangle',
  '939. Minimum Area Rectangle',
  'minimum-area-rectangle',
  'medium',
  'You are given an array of points in the X-Y plane points where points[i] = [xi, yi]. Return the minimum area of a rectangle formed from these points, with sides parallel to the X and Y axes. If there is not any such rectangle, return 0.',
  '[{"input":"points = [[1,1],[1,3],[3,1],[3,3],[2,2]]","output":"4"},{"input":"points = [[1,1],[1,3],[3,1],[3,3],[4,1],[4,3]]","output":"2"}]'::jsonb,
  '["1 <= points.length <= 500","points[i].length == 2","0 <= xi, yi <= 4 * 10^4","All the given points are unique"]'::jsonb,
  '["Array","Hash Table","Math","Geometry","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function minAreaRect(points) {\n  // Your code here\n}","python":"def min_area_rect(points):\n    pass","java":"class Solution {\n    public int minAreaRect(int[][] points) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1],[1,3],[3,1],[3,3],[2,2]]","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use hashmap to store points","For each pair of diagonal points, check if other two corners exist"]'::jsonb,
  52.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-area-rectangle-with-point-constraints-i',
  '3380. Maximum Area Rectangle With Point Constraints I',
  'maximum-area-rectangle-with-point-constraints-i',
  'medium',
  'You are given an array points where points[i] = [xi, yi] represents the coordinates of a point on an X-Y plane. Return the maximum area of a rectangle that can be formed using four points from the given array, where the sides of the rectangle are parallel to the X and Y axes. If no such rectangle can be formed, return 0.',
  '[{"input":"points = [[1,1],[1,3],[3,1],[3,3]]","output":"4"}]'::jsonb,
  '["1 <= points.length <= 10","points[i].length == 2","0 <= xi, yi <= 100","All points are unique"]'::jsonb,
  '["Array","Math","Geometry","Enumeration","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function maxRectangleArea(points) {\n  // Your code here\n}","python":"def max_rectangle_area(points):\n    pass","java":"class Solution {\n    public int maxRectangleArea(int[][] points) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1],[1,3],[3,1],[3,3]]","expectedOutput":"4","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Enumerate all possible rectangles","Check if all four corners exist and no points inside"]'::jsonb,
  42.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'convex-polygon',
  '469. Convex Polygon',
  'convex-polygon',
  'medium',
  'You are given an array of points on the X-Y plane points where points[i] = [xi, yi]. The points form a polygon when joined sequentially. Return true if this polygon is convex and false otherwise. You may assume the polygon formed by given points is always a simple polygon. In other words, we ensure that exactly two edges intersect at each vertex, and that edges otherwise do not intersect each other.',
  '[{"input":"points = [[0,0],[0,5],[5,5],[5,0]]","output":"true"}]'::jsonb,
  '["3 <= points.length <= 10^4","points[i].length == 2","-10^4 <= xi, yi <= 10^4","All the given points are unique"]'::jsonb,
  '["Array","Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function isConvex(points) {\n  // Your code here\n}","python":"def is_convex(points):\n    pass","java":"class Solution {\n    public boolean isConvex(List<List<Integer>> points) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,0],[0,5],[5,5],[5,0]]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use cross product for each triplet","All cross products should have same sign"]'::jsonb,
  39.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'queries-on-number-of-points-inside-a-circle',
  '1828. Queries on Number of Points Inside a Circle',
  'queries-on-number-of-points-inside-a-circle',
  'medium',
  'You are given an array points where points[i] = [xi, yi] is the coordinates of the ith point on a 2D plane. Multiple points can have the same coordinates. You are also given an array queries where queries[j] = [xj, yj, rj] describes a circle centered at (xj, yj) with a radius of rj. For each query queries[j], compute the number of points inside the jth circle. Points on the border of the circle are considered inside. Return an array answer, where answer[j] is the answer to the jth query.',
  '[{"input":"points = [[1,3],[3,3],[5,3],[2,2]], queries = [[2,3,1],[4,3,1],[1,1,2]]","output":"[3,2,2]"}]'::jsonb,
  '["1 <= points.length <= 500","points[i].length == 2","0 <= xi, yi <= 500","1 <= queries.length <= 500","queries[j].length == 3","0 <= xj, yj <= 500","1 <= rj <= 500"]'::jsonb,
  '["Array","Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function countPoints(points, queries) {\n  // Your code here\n}","python":"def count_points(points, queries):\n    pass","java":"class Solution {\n    public int[] countPoints(int[][] points, int[][] queries) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,3],[3,3],[5,3],[2,2]], [[2,3,1],[4,3,1],[1,1,2]]","expectedOutput":"[3,2,2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["For each query, check distance of each point","Distance squared <= radius squared means inside"]'::jsonb,
  87.2,
  '["Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'max-points-on-a-line',
  '149. Max Points on a Line',
  'max-points-on-a-line',
  'hard',
  'Given an array of points where points[i] = [xi, yi] represents a point on the X-Y plane, return the maximum number of points that lie on the same straight line.',
  '[{"input":"points = [[1,1],[2,2],[3,3]]","output":"3"},{"input":"points = [[1,1],[3,2],[5,3],[4,1],[2,3],[1,4]]","output":"4"}]'::jsonb,
  '["1 <= points.length <= 300","points[i].length == 2","-10^4 <= xi, yi <= 10^4","All the points are unique"]'::jsonb,
  '["Array","Hash Table","Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function maxPoints(points) {\n  // Your code here\n}","python":"def max_points(points):\n    pass","java":"class Solution {\n    public int maxPoints(int[][] points) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1],[2,2],[3,3]]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["For each point, count slopes to other points","Use GCD for slope representation"]'::jsonb,
  21.3,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-number-of-visible-points',
  '1610. Maximum Number of Visible Points',
  'maximum-number-of-visible-points',
  'hard',
  'You are given an array points, an integer angle, and your location, where location = [posx, posy] and points[i] = [xi, yi] both denote integral coordinates on the X-Y plane. Initially, you are facing directly east from your position. You cannot move from your position, but you can rotate. In other words, posx and posy cannot be changed. Your field of view in degrees is represented by angle, determining how wide you can see from any given view direction. Let d be the amount in degrees that you rotate counterclockwise from the east direction. Then, your field of view is the inclusive range of angles [d - angle/2, d + angle/2]. You can see some set of points if, for each point, the angle formed by the point, your position, and the immediate east direction from your position is in your field of view. There can be multiple points at one coordinate. The points do not obstruct your vision to other points. Return the maximum number of points you can see.',
  '[{"input":"points = [[2,1],[2,2],[3,3]], angle = 90, location = [1,1]","output":"3"}]'::jsonb,
  '["1 <= points.length <= 10^5","points[i].length == 2","location.length == 2","0 <= angle < 360","0 <= posx, posy, xi, yi <= 100"]'::jsonb,
  '["Array","Math","Geometry","Sliding Window","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function visiblePoints(points, angle, location) {\n  // Your code here\n}","python":"def visible_points(points, angle, location):\n    pass","java":"class Solution {\n    public int visiblePoints(List<List<Integer>> points, int angle, List<Integer> location) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[2,1],[2,2],[3,3]], 90, [1,1]","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Convert points to angles using atan2","Use sliding window on sorted angles"]'::jsonb,
  37.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimize-manhattan-distances',
  '3102. Minimize Manhattan Distances',
  'minimize-manhattan-distances',
  'hard',
  'You are given an array points representing integer coordinates of some points on a 2D plane, where points[i] = [xi, yi]. The distance between two points is defined as their Manhattan distance. Return the minimum possible value for maximum distance between any two points by removing exactly one point.',
  '[{"input":"points = [[3,10],[5,15],[10,2],[4,4]]","output":"12"}]'::jsonb,
  '["3 <= points.length <= 10^5","points[i].length == 2","1 <= points[i][0], points[i][1] <= 10^8"]'::jsonb,
  '["Array","Math","Geometry","Sorting"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumDistance(points) {\n  // Your code here\n}","python":"def minimum_distance(points):\n    pass","java":"class Solution {\n    public int minimumDistance(int[][] points) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[3,10],[5,15],[10,2],[4,4]]","expectedOutput":"12","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Transform to Chebyshev distance","Track max values after removing each point"]'::jsonb,
  48.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'self-crossing',
  '335. Self Crossing',
  'self-crossing',
  'hard',
  'You are given an array of integers distance. You start at point (0,0) on an X-Y plane and you move distance[0] meters to the north, then distance[1] meters to the west, distance[2] meters to the south, distance[3] meters to the east, and so on. In other words, after each move, your direction changes counter-clockwise. Return true if your path crosses itself, and false if it does not.',
  '[{"input":"distance = [2,1,1,2]","output":"true"},{"input":"distance = [1,2,3,4]","output":"false"},{"input":"distance = [1,1,1,1]","output":"true"}]'::jsonb,
  '["1 <= distance.length <= 10^5","1 <= distance[i] <= 10^5"]'::jsonb,
  '["Array","Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function isSelfCrossing(distance) {\n  // Your code here\n}","python":"def is_self_crossing(distance):\n    pass","java":"class Solution {\n    public boolean isSelfCrossing(int[] distance) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[2,1,1,2]","expectedOutput":"true","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Check crossing with 4th, 5th, and 6th previous lines","Three possible crossing patterns"]'::jsonb,
  30.2,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'erect-the-fence',
  '587. Erect the Fence',
  'erect-the-fence',
  'hard',
  'You are given an array trees where trees[i] = [xi, yi] represents the location of a tree in the garden. You are asked to fence the entire garden using the minimum length of rope as it is expensive. The garden is well fenced only if all the trees are enclosed. Return the coordinates of trees that are exactly located on the fence perimeter.',
  '[{"input":"trees = [[1,1],[2,2],[2,0],[2,4],[3,3],[4,2]]","output":"[[1,1],[2,0],[3,3],[2,4],[4,2]]"}]'::jsonb,
  '["1 <= trees.length <= 3000","trees[i].length == 2","0 <= xi, yi <= 100","All the given trees are unique"]'::jsonb,
  '["Array","Math","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function outerTrees(trees) {\n  // Your code here\n}","python":"def outer_trees(trees):\n    pass","java":"class Solution {\n    public int[][] outerTrees(int[][] trees) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,1],[2,2],[2,0],[2,4],[3,3],[4,2]]","expectedOutput":"[[1,1],[2,0],[3,3],[2,4],[4,2]]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use convex hull algorithm","Graham scan or Jarvis march"]'::jsonb,
  45.3,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'minimum-number-of-lines-to-cover-points',
  '2152. Minimum Number of Lines to Cover Points',
  'minimum-number-of-lines-to-cover-points',
  'medium',
  'You are given an array points where points[i] = [xi, yi] represents a point on an X-Y plane. Straight lines are going to be added to the X-Y plane, such that every point is covered by at least one line. Return the minimum number of straight lines needed to cover all the points.',
  '[{"input":"points = [[0,1],[2,3],[4,5],[4,3]]","output":"2"}]'::jsonb,
  '["1 <= points.length <= 10","points[i].length == 2","-100 <= xi, yi <= 100","All the points are unique"]'::jsonb,
  '["Array","Math","Backtracking","Bit Manipulation","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function minimumLines(points) {\n  // Your code here\n}","python":"def minimum_lines(points):\n    pass","java":"class Solution {\n    public int minimumLines(int[][] points) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[0,1],[2,3],[4,5],[4,3]]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use backtracking with bitmask","Try covering points with each possible line"]'::jsonb,
  58.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'nth-magical-number',
  '878. Nth Magical Number',
  'nth-magical-number',
  'hard',
  'A positive integer is magical if it is divisible by either a or b. Given the three integers n, a, and b, return the nth magical number. Since the answer may be very large, return it modulo 10^9 + 7.',
  '[{"input":"n = 1, a = 2, b = 3","output":"2"},{"input":"n = 4, a = 2, b = 3","output":"6"}]'::jsonb,
  '["1 <= n <= 10^9","2 <= a, b <= 4 * 10^4"]'::jsonb,
  '["Math","Binary Search"]'::jsonb,
  'DSA',
  '{"javascript":"function nthMagicalNumber(n, a, b) {\n  // Your code here\n}","python":"def nth_magical_number(n, a, b):\n    pass","java":"class Solution {\n    public int nthMagicalNumber(int n, int a, int b) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"1, 2, 3","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use binary search on answer","Count magical numbers using inclusion-exclusion with LCM"]'::jsonb,
  30.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'detonate-the-maximum-bombs',
  '2101. Detonate the Maximum Bombs',
  'detonate-the-maximum-bombs',
  'medium',
  'You are given a list of bombs. The range of a bomb is defined as the area where its effect can be felt. This area is in the shape of a circle with the center as the location of the bomb. The bombs are represented by a 0-indexed 2D integer array bombs where bombs[i] = [xi, yi, ri]. xi and yi denote the X-coordinate and Y-coordinate of the location of the ith bomb, whereas ri denotes the radius of its range. You may choose to detonate a single bomb. When a bomb is detonated, it will detonate all bombs that lie in its range. These bombs will further detonate the bombs that lie in their ranges. Given the list of bombs, return the maximum number of bombs that can be detonated if you are allowed to detonate only one bomb.',
  '[{"input":"bombs = [[2,1,3],[6,1,4]]","output":"2"},{"input":"bombs = [[1,1,5],[10,10,5]]","output":"1"}]'::jsonb,
  '["1 <= bombs.length <= 100","bombs[i].length == 3","1 <= xi, yi, ri <= 10^5"]'::jsonb,
  '["Array","Math","Depth-First Search","Breadth-First Search","Graph","Geometry"]'::jsonb,
  'DSA',
  '{"javascript":"function maximumDetonation(bombs) {\n  // Your code here\n}","python":"def maximum_detonation(bombs):\n    pass","java":"class Solution {\n    public int maximumDetonation(int[][] bombs) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[2,1,3],[6,1,4]]","expectedOutput":"2","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Build directed graph of which bombs can detonate others","BFS/DFS from each bomb to count chain reaction"]'::jsonb,
  44.8,
  '["Amazon","Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'range-sum-query-mutable',
  '307. Range Sum Query - Mutable',
  'range-sum-query-mutable',
  'medium',
  'Given an integer array nums, handle multiple queries of the following types: Update the value of an element in nums. Calculate the sum of the elements of nums between indices left and right inclusive where left <= right. Implement the NumArray class: NumArray(int[] nums) Initializes the object with the integer array nums. void update(int index, int val) Updates the value of nums[index] to be val. int sumRange(int left, int right) Returns the sum of the elements of nums between indices left and right inclusive (i.e., nums[left] + nums[left + 1] + ... + nums[right]).',
  '[{"input":"[\"NumArray\", \"sumRange\", \"update\", \"sumRange\"]\\n[[[1, 3, 5]], [0, 2], [1, 2], [0, 2]]","output":"[null, 9, null, 8]"}]'::jsonb,
  '["1 <= nums.length <= 3 * 10^4","-100 <= nums[i] <= 100","0 <= index < nums.length","-100 <= val <= 100","0 <= left <= right < nums.length","At most 3 * 10^4 calls will be made to update and sumRange"]'::jsonb,
  '["Array","Design","Binary Indexed Tree","Segment Tree"]'::jsonb,
  'DSA',
  '{"javascript":"class NumArray {\n  constructor(nums) {\n  }\n  update(index, val) {\n  }\n  sumRange(left, right) {\n  }\n}","python":"class NumArray:\n    def __init__(self, nums):\n        pass\n    def update(self, index, val):\n        pass\n    def sum_range(self, left, right):\n        pass","java":"class NumArray {\n    public NumArray(int[] nums) {\n    }\n    public void update(int index, int val) {\n    }\n    public int sumRange(int left, int right) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"NumArray\", \"sumRange\", \"update\", \"sumRange\"], [[[1, 3, 5]], [0, 2], [1, 2], [0, 2]]","expectedOutput":"[null, 9, null, 8]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use segment tree or BIT","Build tree for efficient range queries and updates"]'::jsonb,
  44.7,
  '["Amazon","Google","Facebook"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'range-addition',
  '370. Range Addition',
  'range-addition',
  'medium',
  'You are given an integer length and an array updates where updates[i] = [startIdxi, endIdxi, inci]. You have an array arr of length length with all zeros, and you have some operation to apply on arr. In the ith operation, you should increment all the elements arr[startIdxi], arr[startIdxi + 1], ..., arr[endIdxi] by inci. Return arr after applying all the updates.',
  '[{"input":"length = 5, updates = [[1,3,2],[2,4,3],[0,2,-2]]","output":"[-2,0,3,5,3]"}]'::jsonb,
  '["1 <= length <= 10^5","0 <= updates.length <= 10^4","0 <= startIdxi <= endIdxi < length","-1000 <= inci <= 1000"]'::jsonb,
  '["Array","Prefix Sum"]'::jsonb,
  'DSA',
  '{"javascript":"function getModifiedArray(length, updates) {\n  // Your code here\n}","python":"def get_modified_array(length, updates):\n    pass","java":"class Solution {\n    public int[] getModifiedArray(int length, int[][] updates) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"5, [[1,3,2],[2,4,3],[0,2,-2]]","expectedOutput":"[-2,0,3,5,3]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use difference array technique","Mark start and end+1 positions, then compute prefix sum"]'::jsonb,
  66.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'falling-squares',
  '699. Falling Squares',
  'falling-squares',
  'hard',
  'There are several squares being dropped onto the X-axis of a 2D plane. You are given a 2D integer array positions where positions[i] = [lefti, sideLengthi] represents the ith square with a side length of sideLengthi that is dropped with its left edge aligned with X-coordinate lefti. Each square is dropped one at a time from a height above any landed squares. It then falls downward (negative Y direction) until it either lands on the top side of another square or on the X-axis. A square brushing the left/right side of another square does not count as landing on it. Once it lands, it freezes in place and cannot be moved. After each square is dropped, you must record the height of the current tallest stack of squares. Return an integer array ans where ans[i] represents the height described above after dropping the ith square.',
  '[{"input":"positions = [[1,2],[2,3],[6,1]]","output":"[2,5,5]"},{"input":"positions = [[100,100],[200,100]]","output":"[100,100]"}]'::jsonb,
  '["1 <= positions.length <= 1000","1 <= lefti <= 10^8","1 <= sideLengthi <= 10^6"]'::jsonb,
  '["Array","Segment Tree","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"function fallingSquares(positions) {\n  // Your code here\n}","python":"def falling_squares(positions):\n    pass","java":"class Solution {\n    public List<Integer> fallingSquares(int[][] positions) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[[1,2],[2,3],[6,1]]","expectedOutput":"[2,5,5]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use coordinate compression","Segment tree for range max queries"]'::jsonb,
  45.3,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'maximum-sum-queries',
  '2736. Maximum Sum Queries',
  'maximum-sum-queries',
  'hard',
  'You are given two 0-indexed integer arrays nums1 and nums2, each of length n, and a 1-indexed 2D array queries where queries[i] = [xi, yi]. For the ith query, find the maximum value of nums1[j] + nums2[j] among all indices j (0 <= j < n), where nums1[j] >= xi and nums2[j] >= yi, or -1 if there is no j satisfying the constraints. Return an array answer where answer[i] is the answer to the ith query.',
  '[{"input":"nums1 = [4,3,1,2], nums2 = [2,4,9,5], queries = [[4,1],[1,3],[2,5]]","output":"[6,10,7]"}]'::jsonb,
  '["nums1.length == nums2.length","n == nums1.length","1 <= n <= 10^5","1 <= nums1[i], nums2[i] <= 10^9","1 <= queries.length <= 10^5","queries[i].length == 2","xi == queries[i][0]","yi == queries[i][1]","1 <= xi, yi <= 10^9"]'::jsonb,
  '["Array","Binary Search","Stack","Segment Tree","Sorting","Monotonic Stack"]'::jsonb,
  'DSA',
  '{"javascript":"function maximumSumQueries(nums1, nums2, queries) {\n  // Your code here\n}","python":"def maximum_sum_queries(nums1, nums2, queries):\n    pass","java":"class Solution {\n    public int[] maximumSumQueries(int[] nums1, int[] nums2, int[][] queries) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,3,1,2], [2,4,9,5], [[4,1],[1,3],[2,5]]","expectedOutput":"[6,10,7]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Sort by first dimension","Use segment tree or monotonic stack for second dimension"]'::jsonb,
  31.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'range-sum-query-2d-mutable',
  '308. Range Sum Query 2D - Mutable',
  'range-sum-query-2d-mutable',
  'medium',
  'Given a 2D matrix matrix, handle multiple queries of the following types: Update the value of a cell in matrix. Calculate the sum of the elements of matrix inside the rectangle defined by its upper left corner (row1, col1) and lower right corner (row2, col2). Implement the NumMatrix class: NumMatrix(int[][] matrix) Initializes the object with the integer matrix matrix. void update(int row, int col, int val) Updates the value of matrix[row][col] to be val. int sumRegion(int row1, int col1, int row2, int col2) Returns the sum of the elements of matrix inside the rectangle defined by its upper left corner (row1, col1) and lower right corner (row2, col2).',
  '[{"input":"[\"NumMatrix\", \"sumRegion\", \"update\", \"sumRegion\"]\\n[[[[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 0, 5]]], [2, 1, 4, 3], [3, 2, 2], [2, 1, 4, 3]]","output":"[null, 8, null, 10]"}]'::jsonb,
  '["m == matrix.length","n == matrix[i].length","1 <= m, n <= 200","-10^5 <= matrix[i][j] <= 10^5","0 <= row < m","0 <= col < n","-10^5 <= val <= 10^5","0 <= row1 <= row2 < m","0 <= col1 <= col2 < n","At most 10^4 calls will be made to sumRegion and update"]'::jsonb,
  '["Array","Design","Binary Indexed Tree","Segment Tree","Matrix"]'::jsonb,
  'DSA',
  '{"javascript":"class NumMatrix {\n  constructor(matrix) {\n  }\n  update(row, col, val) {\n  }\n  sumRegion(row1, col1, row2, col2) {\n  }\n}","python":"class NumMatrix:\n    def __init__(self, matrix):\n        pass\n    def update(self, row, col, val):\n        pass\n    def sum_region(self, row1, col1, row2, col2):\n        pass","java":"class NumMatrix {\n    public NumMatrix(int[][] matrix) {\n    }\n    public void update(int row, int col, int val) {\n    }\n    public int sumRegion(int row1, int col1, int row2, int col2) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"NumMatrix\", \"sumRegion\", \"update\", \"sumRegion\"], [[[[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 0, 5]]], [2, 1, 4, 3], [3, 2, 2], [2, 1, 4, 3]]","expectedOutput":"[null, 8, null, 10]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use 2D Binary Indexed Tree","Or use row-based segment trees"]'::jsonb,
  46.3,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'count-of-range-sum',
  '327. Count of Range Sum',
  'count-of-range-sum',
  'hard',
  'Given an integer array nums and two integers lower and upper, return the number of range sums that lie in [lower, upper] inclusive. Range sum S(i, j) is defined as the sum of the elements in nums between indices i and j inclusive, where i <= j.',
  '[{"input":"nums = [-2,5,-1], lower = -2, upper = 2","output":"3"},{"input":"nums = [0], lower = 0, upper = 0","output":"1"}]'::jsonb,
  '["1 <= nums.length <= 10^5","-2^31 <= nums[i] <= 2^31 - 1","-10^5 <= lower <= upper <= 10^5"]'::jsonb,
  '["Array","Binary Search","Divide and Conquer","Binary Indexed Tree","Segment Tree","Merge Sort","Ordered Set"]'::jsonb,
  'DSA',
  '{"javascript":"function countRangeSum(nums, lower, upper) {\n  // Your code here\n}","python":"def count_range_sum(nums, lower, upper):\n    pass","java":"class Solution {\n    public int countRangeSum(int[] nums, int lower, int upper) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[-2,5,-1], -2, 2","expectedOutput":"3","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use prefix sums","Count using merge sort or BIT with coordinate compression"]'::jsonb,
  37.8,
  '["Google","Amazon"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'range-frequency-queries',
  '2080. Range Frequency Queries',
  'range-frequency-queries',
  'medium',
  'Design a data structure that efficiently answers queries about the frequency of a value in a given subarray. Implement the RangeFreqQuery class: RangeFreqQuery(int[] arr) Constructs an instance of the class with the given 0-indexed integer array arr. int query(int left, int right, int value) Returns the frequency of value in the subarray arr[left...right].',
  '[{"input":"[\"RangeFreqQuery\", \"query\", \"query\"]\\n[[[12, 33, 4, 56, 22, 2, 34, 33, 22, 12, 34, 56]], [1, 2, 4], [0, 11, 33]]","output":"[null, 1, 2]"}]'::jsonb,
  '["1 <= arr.length <= 10^5","1 <= arr[i], value <= 10^4","0 <= left <= right < arr.length","At most 10^5 calls will be made to query"]'::jsonb,
  '["Array","Hash Table","Binary Search","Design","Segment Tree"]'::jsonb,
  'DSA',
  '{"javascript":"class RangeFreqQuery {\n  constructor(arr) {\n  }\n  query(left, right, value) {\n  }\n}","python":"class RangeFreqQuery:\n    def __init__(self, arr):\n        pass\n    def query(self, left, right, value):\n        pass","java":"class RangeFreqQuery {\n    public RangeFreqQuery(int[] arr) {\n    }\n    public int query(int left, int right, int value) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[\"RangeFreqQuery\", \"query\", \"query\"], [[[12, 33, 4, 56, 22, 2, 34, 33, 22, 12, 34, 56]], [1, 2, 4], [0, 11, 33]]","expectedOutput":"[null, 1, 2]","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Store indices for each value","Use binary search on stored indices"]'::jsonb,
  42.7,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  'longest-increasing-subsequence-ii',
  '2407. Longest Increasing Subsequence II',
  'longest-increasing-subsequence-ii',
  'hard',
  'You are given an integer array nums and an integer k. Find the longest subsequence of nums that meets the following requirements: The subsequence is strictly increasing and the difference between adjacent elements in the subsequence is at most k. Return the length of the longest subsequence that meets the requirements. A subsequence is an array that can be derived from another array by deleting some or no elements without changing the order of the remaining elements.',
  '[{"input":"nums = [4,2,1,4,3,4,5,8,15], k = 3","output":"5"},{"input":"nums = [7,4,5,1,8,12,4,7], k = 5","output":"4"}]'::jsonb,
  '["1 <= nums.length <= 10^5","1 <= nums[i], k <= 10^5"]'::jsonb,
  '["Array","Dynamic Programming","Segment Tree","Binary Indexed Tree","Queue","Monotonic Queue"]'::jsonb,
  'DSA',
  '{"javascript":"function lengthOfLIS(nums, k) {\n  // Your code here\n}","python":"def length_of_lis(nums, k):\n    pass","java":"class Solution {\n    public int lengthOfLIS(int[] nums, int k) {\n    }\n}"}'::jsonb,
  '[{"id":"1","input":"[4,2,1,4,3,4,5,8,15], 3","expectedOutput":"5","hidden":false}]'::jsonb,
  '[]'::jsonb,
  '["Use segment tree for range max DP","For each num, query max LIS in range [num-k, num-1]"]'::jsonb,
  25.8,
  '["Google"]'::jsonb,
  2,
  256
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();


-- Migration complete!
-- Total problems in mockData: 408
-- Problems inserted: 407
-- Duplicates skipped: 1
-- All problems are now in the database with proper test cases

<template>
  <div class="details">
    <!--    <h1 class="title">problem description</h1>-->
    <div style=" width: auto">
      <div style="width: 50%;float: left">
        <el-tabs v-model="cur_name">
          <el-tab-pane label="description" name="first">
            <div class="markdown-body" v-html="this.value"></div>
          </el-tab-pane>
          <el-tab-pane label="records" name="second">your records</el-tab-pane>
        </el-tabs>

      </div>
      <div style="width: 45%;float: right">
        <el-select v-model="lan" placeholder="language" style="margin: 10px 0">
          <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value"
              :disabled="item.disabled">
          </el-option>
        </el-select>
        <el-input
            type="textarea"
            :rows="35"
            placeholder="your code"
            v-model="textarea"
            style="margin: 10px 0">
        </el-input>
        <el-button type="success" plain style="margin: 5px 0;float: right">submit</el-button>
        <!--el-button type="success" plain style="margin: 5px 0;float: right">{{this.button_name}}</el-button-->
      </div>
    </div>
  </div>
</template>

<script>
import {marked} from "marked";
import "./markdown.css"
import Common from "@/components/Common"

export default {
  name: 'Details',
  data() {
    return {
      backend: Common.addr,
      cur_name: 'first',
      lan: '',
      options: [{
        value: 'python',
        label: 'python'
      }, {
        value: 'c++',
        label: 'c++',
        disabled: true
      }, {
        value: 'Java',
        label: 'Java',
        disabled: true
      }, {
        value: 'Golang',
        label: 'Golang',
        disabled: true
      }, {
        value: 'Javascript',
        label: 'Javascript',
        disabled: true
      }],
      textarea: '',
      value: '### [1\\. Two Sum](https://leetcode.com/problems/two-sum/)\n' +
          '\n' +
          'Difficulty: **Easy**\n' +
          '\n' +
          'Related Topics: [Array](https://leetcode.com/tag/array/), [Hash Table](https://leetcode.com/tag/hash-table/)\n' +
          '\n' +
          '\n' +
          'Given an array of integers `nums` and an integer `target`, return _indices of the two numbers such that they add up to `target`_.\n' +
          '\n' +
          'You may assume that each input would have **_exactly_ one solution**, and you may not use the _same_ element twice.\n' +
          '\n' +
          'You can return the answer in any order.\n' +
          '\n' +
          '**Example 1:**\n' +
          '\n' +
          '```\n' +
          'Input: nums = [2,7,11,15], target = 9\n' +
          'Output: [0,1]\n' +
          'Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].\n' +
          '```\n' +
          '\n' +
          '**Example 2:**\n' +
          '\n' +
          '```\n' +
          'Input: nums = [3,2,4], target = 6\n' +
          'Output: [1,2]\n' +
          '```\n' +
          '\n' +
          '**Example 3:**\n' +
          '\n' +
          '```\n' +
          'Input: nums = [3,3], target = 6\n' +
          'Output: [0,1]\n' +
          '```\n' +
          '\n' +
          '**Constraints:**\n' +
          '\n' +
          '*   `2 <= nums.length <= 10<sup>4</sup>`\n' +
          '*   `-10<sup>9</sup> <= nums[i] <= 10<sup>9</sup>`\n' +
          '*   `-10<sup>9</sup> <= target <= 10<sup>9</sup>`\n' +
          '*   **Only one valid answer exists.**\n' +
          '\n' +
          '**Follow-up: **Can you come up with an algorithm that is less than `O(n<sup>2</sup>) `time complexity?\n' +
          '\n' +
          '#### Solution\n' +
          '\n' +
          'Language: **C++**\n' +
          '\n' +
          '```c++\n' +
          'class Solution {\n' +
          'public:\n' +
          '    vector<int> twoSum(vector<int>& nums, int target) {\n' +
          '        \n' +
          '    }\n' +
          '};\n' +
          '```'
    }
  },
  created() {
    this.value = marked(this.value)
  }
}
</script>

<style lang="stylus">
.details
  padding 20px
  margin 0 auto

  .title
    font-size 28px
    padding 0 0 30px 0

</style>

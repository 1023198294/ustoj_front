<template>
  <div class="details">
    <!--    <h1 class="title">problem description</h1>-->
    <div style=" width: auto">
      <div style="width: 50%;float: left">
        <el-tabs v-model="cur_name">
          <el-tab-pane label="description" name="first">
            <div class="markdown-body" v-html="this.value"></div>
          </el-tab-pane>
          <el-tab-pane label="records" name="second">
            <el-table
                :data="records"
                style="width: 100%"
                :row-class-name="tableRowClassName">
              <el-table-column
                  prop="status"
                  label="running status"
              >
              </el-table-column>
              <el-table-column
                  prop="submit_time"
                  label="submit time"
              >
              </el-table-column>
              <el-table-column
                  prop="language"
                  label="language"
              >
              </el-table-column>
              <el-table-column
                  prop="run_time"
                  label="running time"
              >
              </el-table-column>
            </el-table>
          </el-tab-pane>
        </el-tabs>

      </div>
      <div style="width: 45%;float: right">
        <el-select v-model="lan" placeholder="language" style="margin: 10px 0" @change="handleLanguageChange">
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
        <el-button type="success" plain style="margin: 5px 0;float: right" @click="handleSubmitCode">submit</el-button>
        <!--el-button type="success" plain style="margin: 5px 0;float: right">{{this.button_name}}</el-button-->
      </div>
    </div>
  </div>
</template>

<script>
import {marked} from "marked";
import "./markdown.css"
import Common from "@/components/Common"
import axios from "@/axios";

export default {
  name: 'Details',
  methods: {
    tableRowClassName({row, rowIndex}) {
      if (row.status === "running") {
        return 'warning-row'
      } else if (row.status === "wrong answer") {
        return 'fail-row'
      } else if (row.status === "done")
        return 'success-row'

      if (rowIndex === 1) {
        return 'warning-row';
      } else if (rowIndex === 3) {
        return 'success-row';
      }
      return '';
    },
    handleLanguageChange(language) {
      if (language === "python") {
        this.textarea = this.python_default
        this.language = "python"
      }
    },
    handleSubmitCode() {
      if (this.language === "") {
        this.$notify({
          title: 'warning',
          message: 'please select the programing language',
          duration: 2000,
          type: 'error'
        })
        return
      }
      this.submit_loading = true
      axios.getSubmit({
        "problem_id": this.$route.query.problem_id,
        "language": this.language,
        "code": this.textarea
      }).then((res) => {
        if (res) {
          this.submit_loading = false
        }
      })
    }
  },
  data() {
    return {
      backend: Common.addr,
      cur_name: 'first',
      lan: '',
      options: [
        {
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
      records_mock: [
        {
          "status": "wrong answer", // done wa
          "submit_time": "2022-05-05 15:40:07",
          "language": "Python",
          "run_time": "10ms"
        },
        {
          "status": "running", // done wa
          "submit_time": "2022-05-05 15:47:03",
          "language": "Python",
          "run_time": "100ms"
        },
        {
          "status": "done", // done wa
          "submit_time": "2022-05-05 16:01:24",
          "language": "Python",
          "run_time": "50ms"
        }
      ],
      records: [],
      textarea: "",
      python_default: "import sys\n" +
          "\n" +
          "def solve(arr):\n" +
          "    pass\n" +
          "\n" +
          "if __name__ == '__main__':\n" +
          "    tcase = int(input().strip())\n" +
          "    for case in range(tcase):\n" +
          "        a, b = map(int, input().strip().split())\n" +
          "        print(a + b)",
      value: '',
      language: '',
      submit_loading: false
    }
  },
  created() {
    //this.value = marked(this.value)
  },
  beforeMount() {
    //console.log(this.$route.query.problem_id)
    axios.getProblemDetails({
      "problem_id": this.$route.query.problem_id
    }).then((res) => {
      console.log(res.data)
      this.value = marked(res.data.description)
    })
    axios.getResultList({
      "problem_id": this.$route.query.problem_id
    }).then((res) => {
      for (let i = 0; i < res.data.length; i++) {
        this.records.push(res.data[i])
      }
    })
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

  .el-table .warning-row {
    background: oldlace;
  }

  .el-table .success-row {
    background: #f0f9eb;
  }

  .el-table .fail-row {
    background: #ffeef0;
  }
</style>

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
                  prop="submission_time"
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
        <el-button type="success" plain style="margin: 5px 0;float: right" @click="handleSubmitCode"
                   :loading="submit_loading">submit
        </el-button>
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
    // eslint-disable-next-line no-unused-vars
    tableRowClassName({row, _}) {
      if (row.status === "running" || row.status === "submitted") {
        return 'warning-row'
      } else if (row.status === "wrong answer") {
        return 'fail-row'
      } else if (row.status === "done" || row.status === "accepted")
        return 'success-row'
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
        "problem_id": parseInt(this.$route.query.problem_id),
        "language": this.language,
        "code": this.textarea
      }).then((res) => {
        if (res) {
          if (res.status === 200 && res.data && res.data.code === 0) {
            this.submit_loading = false
            this.refresh()
          } else {
            this.$notify({
              title: 'Error',
              message: 'cannot submit the code',
              duration: 2000,
              type: "error"
            })
            this.submit_loading = false
          }
        }
      })
    },
    refresh() {
      axios.getResultList({
        "problem_id": this.$route.query.problem_id,
      }).then((res) => {
            if (res && res.status === 200 && res.data && res.data.code === 0) {
              this.records = []
              for (let i = 0; i < res.data.records.length; i++) {
                this.records.push(res.data.records[i])
              }
              console.log("current record")
              console.log(this.records)
            } else {
              this.$notify({
                title: "Error",
                message: "unable to get results, please refresh this page",
                duration: 2000,
                type: "error"
              })
              clearInterval(this.timer)
            }
          }
      )
    }
  },
  data() {
    return {
      timer: null,
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
          "    args = sys.argv[1:]\n" +
          "    # sample\n" +
          "    tcase = int(args[0])\n" +
          "    for i in range(tcase):\n" +
          "        # a, b = map(int, input().strip().split())\n" +
          "        a = int(args[i+1])\n" +
          "        b = int(args[i+2])\n" +
          "        print(a + b)",
      value: '',
      language: '',
      submit_loading: false
    }
  },
  created() {
    this.timer = setInterval(() => {
      console.log("timer")
      this.refresh()
    }, 5000);
  },
  beforeMount() {
    //console.log(this.$route.query.problem_id)
    axios.getProblemDetails({
      "problem_id": this.$route.query.problem_id
    }).then((res) => {
      // console.log(res.data)
      if (res && res.status === 200 && res.data && res.data.code === 0) {
        this.value = marked(res.data.description)
      } else {
        this.$notify({
          title: "Error",
          type: "error",
          message: "unable to get problem description, please refresh the page",
          duration: 2000,

        })
      }
    })
    this.refresh()
  },
  beforeDestroy() {
    clearInterval(this.timer)
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

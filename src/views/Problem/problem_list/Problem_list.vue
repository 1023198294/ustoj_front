<template>
  <div class="collection">
    <el-dialog title="新建商品" :visible.sync="dialogFormVisible">
      <el-form :model="newForm">
        <el-form-item label="名称" :label-width="formLabelWidth">
          <el-input v-model="newForm.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="类型" :label-width="formLabelWidth">
          <el-select v-model="newForm.region" placeholder="请选择商品类型">
            <el-option label="111" value="MySQL"></el-option>
            <el-option label="Oracle" value="Oracle"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="地址" :label-width="formLabelWidth">
          <el-input v-model="newForm.address" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="用户名" :label-width="formLabelWidth">
          <el-input v-model="newForm.username" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="密码" :label-width="formLabelWidth">
          <el-input v-model="newForm.password" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="描述" :label-width="formLabelWidth">
          <el-input v-model="newForm.describe" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogFormVisible = false">测试连接</el-button>
        <el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <div class="table-box">
      <el-table
          ref="multipleTable"
          :data="tableData"
          tooltip-effect="dark"
          style="width: 100%"
          @selection-change="handleSelectionChange">
        <el-table-column
            prop="problem_name"
            label="title"
            width="180"
            align="left">
        </el-table-column>
        <el-table-column
            prop="acceptance"
            label="acceptance"
            width=""
            align="center">
        </el-table-column>
        <el-table-column
            prop="difficulty"
            label="difficulty"
            width=""
            align="center">
        </el-table-column>
        <el-table-column
            label="operation"
            width="300"
            align="center">
          <template slot-scope="scope">
            <!--            <el-button type="primary" size="small" @click="handleDelete">删除</el-button>
                        <el-button type="primary" size="small" @click="handleEdit">编辑</el-button>-->
            <el-button type="success" size="small" @click="handleOperate(scope.row)">detail</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>

import axios from "@/axios";

export default {
  name: 'Collection',
  data() {
    return {
      pageNumber: 0,
      pageSize: 10,
      tableData: [],
      dialogFormVisible: false,
      newForm: {
        name: '',
        origin: '',
        region: '',
        date1: '',
        date2: '',
        delivery: false,
        type: [],
        resource: '',
        desc: ''
      },
      formLabelWidth: '120px'
    }
  },
  beforeMount() {
    this.handleGetProblemList();
  },
  methods: {
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    handleOperate(ele) {
      this.$router.push({
        path: '/problem/problem_detail?problem_id=' + ele.problem_id,
      })
    },
    handleDelete() {
      this.$notify({
        title: '警告',
        message: '不能删除',
        duration: 2000,
        type: 'error'
      })
    },
    handleEdit() {
      this.$message({
        showClose: true,
        message: '没有编辑权限',
        duration: 2000,
        type: 'error'
      })
    },
    handleTest() {
      const appData = require('./mock.json');
      for (let appDataKey in appData) {
        this.tableData.push(appData[appDataKey])
      }
    },
    handleGetProblemList() {
      // const appData = require('./mock.json');
      // for (let appDataKey in appData) {
      //   this.tableData.push(appData[appDataKey])
      // }
      axios.getProblems({
        "page": this.pageNumber,
        "page_size": this.pageSize
      }).then((res) => {
        // console.log(res.data)
        if (res.status === 200 && res.data && res.data.code === 0) {
          for (let i = 0; i < res.data.problemlist.length; i++) {
            this.tableData.push(res.data.problemlist[i])
          }
        } else {
          this.$notify({
            title: "error",
            message: "unable to load the problems",
            duration: 2000,
            type: "error"
          })
        }

      })
    }
  }
}
</script>

<style lang="stylus">
.collection
  // max-width 1100px
  margin 40px auto

  .new
    width 100%
    margin-bottom 20px
    height 40px
    background #fff
    display flex
    align-items center
    justify-content center
    cursor pointer

    i
      color #03A9F4
      padding-right 10px

  .page
    height 40px
    margin-top 20px
    display flex
    align-items center
    justify-content flex-end

    .el-pagination
      background #fff

</style>

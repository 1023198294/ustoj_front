<template>
  <div>
    <div class="loading-wrapper" v-show="showLoading">
      <Loading></Loading>
    </div>
    <div class="register-wrapper" v-show="!showLoading">
      <img :src="imgUrl" alt="" width="100%" height="100%">
      <div id="register">
        <p class="title">Vue-Element-Demo</p>
        <el-form
            :model="ruleForm2"
            status-icon
            :rules="rules2"
            ref="ruleForm2"
            label-width="0"
            class="demo-ruleForm"
        >
          <el-form-item prop="username">
            <el-input v-model="ruleForm2.username" auto-complete="off" placeholder="username"></el-input>
          </el-form-item>
          <el-form-item prop="email">
            <el-input v-model="ruleForm2.email" auto-complete="off" placeholder="email"></el-input>
          </el-form-item>
          <!--el-form-item prop="smscode" class="code">
            <el-input v-model="ruleForm2.smscode" placeholder="验证码"></el-input>
            <el-button type="primary" :disabled='isDisabled' @click="sendCode">{{buttonText}}</el-button>
          </el-form-item-->
          <el-form-item prop="pass">
            <el-input type="password" v-model="ruleForm2.pass" auto-complete="off" placeholder="password"></el-input>
          </el-form-item>
          <el-form-item prop="checkPass">
            <el-input type="password" v-model="ruleForm2.checkPass" auto-complete="off" placeholder="confirm password"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="submitForm('ruleForm2')" style="width:100%;">Register</el-button>
            <p class="login" @click="gotoLogin">Login</p>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '../../axios.js'
import CryptoJS from 'crypto-js' // md5 加密
import Loading from '@/components/loading/Loading.vue'

export default {
  name: "Register",
  components: {
    Loading
  },
  data() {
    let checkName = (rule, value, callback) => {
      if (value.trim() === '') {
        callback(new Error('Please input the username'))
      } else {
        callback()
      }
    }
    let checkTel = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please input the email'))
      } else if (!this.checkEmail(value)) {
        callback(new Error('Invalid email'))
      } else {
        callback()
      }
    }
    let checkSmscode = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入手机验证码'))
      } else {
        callback()
      }
    }
    let validatePass = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("Please input the password"))
      } else {
        if (this.ruleForm2.checkPass !== "") {
          this.$refs.ruleForm2.validateField("checkPass");
        }
        callback()
      }
    }
    let validatePass2 = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("Please re-input the password"));
      } else if (value !== this.ruleForm2.pass) {
        callback(new Error("Inconsistent password"));
      } else {
        callback();
      }
    };
    return {
      showLoading: true,
      imgUrl: require('../../assets/images/bg-img-1.jpg'),
      ruleForm2: {
        username: "",
        pass: "",
        checkPass: "",
        email: "",
        smscode: ""
      },
      rules2: {
        username: [{validator: checkName, trigger: 'change'}],
        pass: [{validator: validatePass, trigger: 'change'}],
        checkPass: [{validator: validatePass2, trigger: 'change'}],
        email: [{validator: checkTel, trigger: 'change'}],
        smscode: [{validator: checkSmscode, trigger: 'change'}],
      },
      buttonText: '发送验证码',
      isDisabled: false, // 是否禁止点击发送验证码按钮
      flag: true
    }
  },
  mounted() {
    let bgImg = new Image()
    bgImg.src = this.imgUrl
    bgImg.onerror = () => {
      console.log('img onerror')
    }
    bgImg.onload = () => { // 图片加载成功后 去除 loading
      this.showLoading = false
    }
  },
  methods: {
    sendCode() {
      let email = this.ruleForm2.email
      if (this.checkEmail(email) && this.ruleForm2.username) {
        console.log(email)

        // 发送验证码
        axios.userVerify({
          username: encodeURIComponent(this.ruleForm2.username),
          email: this.ruleForm2.email
        }).then((res) => {
          if (res.status === 200 && res.data && res.data.code === 0) {
            this.$notify({
              title: '成功',
              message: '验证码发送成功，请注意查收。有效期5分钟。',
              duration: 1000,
              type: 'success'
            })

            let time = 300
            this.buttonText = '已发送'
            this.isDisabled = true
            if (this.flag) {
              this.flag = false;
              let timer = setInterval(() => {
                time--;
                this.buttonText = time + ' 秒'
                if (time === 0) {
                  clearInterval(timer);
                  this.buttonText = '重新获取'
                  this.isDisabled = false
                  this.flag = true;
                }
              }, 1000)
            }
          } else {
            this.$notify({
              title: '失败',
              message: res.data.msg,
              duration: 1000,
              type: 'error'
            })
          }
        })
      }
    },
    submitForm(formName) {
      this.$refs[formName].validate(valid => {
        if (valid) {
          axios.userRegister({
            username: this.ruleForm2.username,
            password: this.ruleForm2.pass,
            email: this.ruleForm2.email,
            //code: this.ruleForm2.smscode
          }).then((res) => {
            if (res.status === 200) {
              // console.log(res.data.code)
              if (res.data && res.data.code === 0) {
                this.$notify({
                  title: 'Success',
                  message: 'register success',
                  duration: 2000,
                  type: 'success'
                })
                setTimeout(() => {
                  this.$router.push({
                    path: '/login'
                  })
                }, 500)
              } else {
                this.$notify({
                  title: 'Error',
                  message: res.data.msg,
                  duration: 2000,
                  type: 'error'
                })
              }
            } else {
              this.$notify({
                title: 'Error',
                message: `Server error, error code${res.status}`,
                duration: 2000,
                type: 'error'
              })
            }
          })


        } else {
          console.log("error submit!!");
          return false;
        }
      })
    },
    gotoLogin() {
      this.$router.push({
        path: "/login"
      });
    },
    // 验证邮箱
    checkEmail(str) {
      let re = /^(?:\w+\.?)*\w+@(?:\w+\.)*\w+$/
      if (re.test(str)) {
        return true;
      } else {
        return false;
      }
    }
  }
};
</script>

<style scoped>
.loading-wrapper {
  position: fixed;
  top: 0;
  right: 0;
  left: 0;
  bottom: 0;
  background: #aedff8;
  display: flex;
  align-items: center;
  justify-content: center;
}

.register-wrapper img {
  position: absolute;
  z-index: 1;
}

.register-wrapper {
  position: fixed;
  top: 0;
  right: 0;
  left: 0;
  bottom: 0;
}

#register {
  max-width: 340px;
  margin: 60px auto;
  background: #fff;
  padding: 20px 40px;
  border-radius: 10px;
  position: relative;
  z-index: 9;
}

.title {
  font-size: 26px;
  line-height: 50px;
  font-weight: bold;
  margin: 10px;
  text-align: center;
}

.el-form-item {
  text-align: center;
}

.login {
  margin-top: 10px;
  font-size: 14px;
  line-height: 22px;
  color: #1ab2ff;
  cursor: pointer;
  text-align: left;
  text-indent: 8px;
  width: 160px;
}

.login:hover {
  color: #2c2fd6;
}

.code >>> .el-form-item__content {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.code button {
  margin-left: 20px;
  width: 140px;
  text-align: center;
}

.el-button--primary:focus {
  background: #409EFF;
  border-color: #409EFF;
  color: #fff;
}

@media (max-width: 768px) {
  #register {
    max-width: 260px;
    margin: 60px auto;
    background: #fff;
    padding: 10px 20px;
    border-radius: 10px;
    position: relative;
    z-index: 9;
  }
}
</style>

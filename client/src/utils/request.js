import axios from 'axios'

const service = axios.create({
  baseURL: 'http://localhost/DailyReview/server/',
  timeout: 5000
})

service.interceptors.request.use(config => {
  // 可在此处统一处理token等请求头
  return config
})

export default service
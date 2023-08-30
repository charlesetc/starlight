function WriteBody()
  Write([[<h1>hi there you!</h1>]])
end

function WriteHTML()
  SetStatus(200)
  SetHeader('Content-Type', 'text/html; charset=utf-8')
  Write([[<!DOCTYPE>]])
  Write([[<head>]])
  Write([[<title>starlight</title>]])
  Write([[<script src="/js/framework.js">]])
  Write([[</script>]])
  Write([[</head>]])
  Write([[<body>]])
  WriteBody()
  Write([[</body>]])
end

WriteHTML()

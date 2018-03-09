const glob    = require('glob')
const nib     = require('nib')
const gulp    = require('gulp')
const stylus  = require('gulp-stylus')
const plumber = require('gulp-plumber')
const notify  = require('gulp-notify')
const rename  = require('gulp-rename')

gulp.task("ampcss", () =>
	gulp.src(["./amp-template/style/amp-style.styl"])
	  	.pipe(plumber({
	  		errorHandler : notify.onError("<%= error.message %>")
	  	}))
	  	.pipe(stylus({
		    use		 : [nib()],
		    compress : false,
		    linenos  : false
	  	}))
	  	.pipe(rename( path => path.basename = 'sample-amp'))
	  	.pipe(gulp.dest("./amp-template/sample/"))
)
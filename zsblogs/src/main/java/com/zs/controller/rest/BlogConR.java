package com.zs.controller.rest;

import com.zs.entity.Blog;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.entity.other.UploadFileResult;
import com.zs.service.BlogSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Constans;
import com.zs.tools.DownloadImg;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;
import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/blog")
public class BlogConR extends BaseRestController<Blog, Integer> {

    private Logger log = Logger.getLogger(getClass());

    private MailManager mail = MailManager.getInstance();

    @Resource
    private DownloadImg downloadImg;

    @Resource
    private BlogSer blogSer;

    /**
     * 分页查询
     *
     * @param accept
     * @param req
     * @param resp
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @Override
    public EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
        if (accept != null) {
            try {
                accept.setSort(ColumnName.transToUnderline(accept.getSort()));
                return blogSer.queryFenye(accept);
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
                return null;
            }
        }
        return null;
    }

    /**
     * 查询某个博客文章
     *
     * @param id
     * @param req
     * @param resp
     * @return
     */
    @RequestMapping(value = "/one", method = RequestMethod.GET)
    @Override
    public Result<Blog> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
        if (id != null) {
            try {
                Users user = Constans.getUserFromReq(req);
                blogSer.read(user != null ? user.getId() : null, id);
                Blog blog = blogSer.get(id);
                //你访问的不是隐藏博客，或者这是你的博客，才能访问
                boolean isableRead = false;
                if (blog.getIshide().equals("1")) {
                    if (user != null && blog.getUser().getId() == user.getId()) {
                        isableRead = true;
                    }
                } else {
                    isableRead = true;
                }
                if (isableRead) {
                    return new Result<Blog>(SUCCESS, Code.SUCCESS, blog);
                } else {
                    return new Result<Blog>(ERROR, Code.ERROR, null, "该文章不存在，或者你无权查看该文章，抱歉！");
                }
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
            }
        }
        return new Result<Blog>(ERROR, Code.ERROR, null);
    }

    @RequestMapping(value = "", method = RequestMethod.POST)
    public Result<String> doAdd(Blog obj, HttpServletRequest req, HttpServletResponse resp) {
        if (obj != null) {
            try {
                return new Result<String>(SUCCESS, Code.SUCCESS, blogSer.add(obj));
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
            }
        }
        return new Result<String>(ERROR, Code.ERROR, null);
    }


    @RequestMapping(value = "", method = RequestMethod.PUT)
    @Override
    public Result<String> doUpdate(Blog obj, HttpServletRequest req, HttpServletResponse resp) {
        if (obj != null && obj.getId() != null) {
            try {
                return new Result<String>(SUCCESS, Code.SUCCESS, blogSer.update(obj));
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
            }
        }
        return new Result<String>(ERROR, Code.ERROR, null);
    }

    @RequestMapping(value = "/one", method = RequestMethod.DELETE)
    @Override
    public Result<String> doDeleteFalse(Integer id, HttpServletRequest req, HttpServletResponse resp) {
        if (id != null) {
            try {
                return new Result<String>(SUCCESS, Code.SUCCESS, blogSer.delete(id));
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
            }
        }
        return new Result<String>(ERROR, Code.ERROR, null);
    }

    @Override
    public Result<String> doDeleteTrue(Integer id, HttpServletRequest req, HttpServletResponse resp) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Result<String> excelExport(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Result<String> excelImport(MultipartFile file, HttpServletRequest req, HttpServletResponse resp) {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * 博客里面的上传图片
     *
     * @param file
     * @param req
     * @param resp
     * @return
     */
    @RequestMapping(value = "/file/upload", method = RequestMethod.POST)
    public UploadFileResult fileUpload(MultipartFile file, HttpServletRequest req, HttpServletResponse resp) {
        if (file != null && !file.isEmpty()) {
            try {
                List<String> data = new ArrayList<>();
                String re = downloadImg.writeImageToDisk(file.getInputStream(), file.getOriginalFilename());
                data.add("/tomcat_imgs/" + re);
                return new UploadFileResult().setErrno(0).setData(data);
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
                return new UploadFileResult().setErrno(1);
            }
        }
        return new UploadFileResult().setErrno(-1);
    }
}

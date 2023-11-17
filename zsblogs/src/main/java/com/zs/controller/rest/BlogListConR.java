package com.zs.controller.rest;

import com.zs.entity.BlogList;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.service.BlogListSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Constans;
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
import java.util.Date;
import java.util.List;

/**
 * 博客栏目管理
 */
@RestController
@RequestMapping("/api/blogList")
public class BlogListConR extends BaseRestController<BlogList, Integer> {

    private Logger log = Logger.getLogger(getClass());

    private MailManager mail = MailManager.getInstance();

    @Resource
    private BlogListSer blogListSer;

    /**
     * 分页查询，最新博客的查询所有博客的接口
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
                Users user = (Users) req.getAttribute("[user]");
                accept.setInt1(user.getId());
                accept.setSort(ColumnName.transToUnderline(accept.getSort()));
                return blogListSer.queryFenye(accept);
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
                return null;
            }
        }
        return null;
    }

    @RequestMapping(value = "/one", method = RequestMethod.GET)
    @Override
    public Result<BlogList> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
        if (id != null) {
            try {
                return new Result<BlogList>(SUCCESS, Code.SUCCESS, blogListSer.get(id));
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
            }
        }
        return new Result<BlogList>(ERROR, Code.ERROR, null);
    }

    @RequestMapping(value = "", method = RequestMethod.POST)
    @Override
    public Result<String> doAdd(BlogList obj, HttpServletRequest req, HttpServletResponse resp) {
        Users user = (Users) req.getAttribute("[user]");
        if (obj != null) {
            try {
                obj.setCreateTime(new Date());
                obj.setuId(user.getId());
                return new Result<String>(SUCCESS, Code.SUCCESS, blogListSer.add(obj));
            } catch (Exception e) {
                e.printStackTrace();
                mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
            }
        }
        return new Result<String>(ERROR, Code.ERROR, null);
    }

    @RequestMapping(value = "", method = RequestMethod.PUT)
    @Override
    public Result<String> doUpdate(BlogList obj, HttpServletRequest req, HttpServletResponse resp) {
        if (obj != null) {
            try {
                return new Result<String>(SUCCESS, Code.SUCCESS, blogListSer.update(obj));
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
                return new Result<String>(SUCCESS, Code.SUCCESS, blogListSer.delete(id));
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
     * 查询某个用户的所有博客栏目
     *
     * @param req
     * @return
     */
    @RequestMapping(value = "/user/all", method = RequestMethod.GET)
    public Result<List<BlogList>> getUserBlogList(HttpServletRequest req) {
        try {
            Users user = Constans.getUserFromReq(req);
            return new Result<List<BlogList>>(SUCCESS, Code.SUCCESS, blogListSer.queryAll(user.getId()));
        } catch (Exception e) {
            e.printStackTrace();
            mail.addMail(new MailModel(Trans.strToHtml(e, req), MailManager.TITLE));
            return new Result<List<BlogList>>(ERROR, Code.ERROR, null);
        }
    }

}

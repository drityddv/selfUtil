package xiaozhang.spider;

import java.util.ArrayList;
import java.util.List;

import org.jsoup.helper.StringUtil;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import us.codecraft.webmagic.selector.LinksSelector;

/**
 * @author : xiaozhang
 * @since : 2022/6/26 00:28
 */

public class MeiJuFenSelector extends LinksSelector {

    @Override
    public List<String> selectList(Element element) {
        Elements elements = element.select("a");
        List<String> links = new ArrayList<String>(elements.size());
        for (Element element0 : elements) {
            String url = null;
            if (!StringUtil.isBlank(element0.baseUri())) {
                url = element0.attr("abs:href");
            } else {
                url = element0.attr("href");
            }

            if (StringUtil.isBlank(url)) {
                url = element0.attr("href");
            }
            if (!StringUtil.isBlank(url)) {
                links.add(url);
            }
        }
        return links;
    }
}

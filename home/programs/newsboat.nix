{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        newsboat = {
          enable = true;
          autoReload = true;
          reloadThreads = 11;
          extraConfig = ''
            bind-key h quit
            bind-key j down
            bind-key k up
            bind-key l open
            bind-key H prev-feed
            bind-key L next-feed
            bind-key g home
            bind-key G end
            bind-key SPACE macro-prefix
            bind-key RIGHT open
            bind-key LEFT quit
            bind-key b bookmark
            bind-key ^F pagedown
            bind-key ^B pageup
            bind-key ^H toggle-show-read-feeds
            bind-key ^Q quit

            color article             default default
            color background          default default
            color hint-description    default blue
            color hint-key            white   magenta bold
            color hint-keys-delimiter white   blue
            color hint-separator      default blue    bold
            color info                white   blue    bold
            color listfocus           default blue    bold
            color listfocus_unread    white   blue    bold
            color listnormal          white   default
            color listnormal_unread   white   default bold
            color title               white   blue    bold
          '';
          urls = [
            {
              title = "Self: TED-Ed Blog";
              url = "https://blog.ed.ted.com/feed";
              tags = [
                "self"
              ];
            }
            {
              title = "Self: TED Ideas";
              url = "https://ideas.ted.com/feed";
              tags = [
                "self"
              ];
            }
            {
              title = "Self: Feld Thoughts";
              url = "https://feld.com/archives/tag/blog/feed";
              tags = [
                "startup"
              ];
            }
            {
              title = "Self: Steve Blank";
              url = "https://steveblank.com/feed";
              tags = [
                "startup"
              ];
            }
            {
              title = "Self: David Walsh";
              url = "https://davidwalsh.name/feed";
              tags = [
                "personal"
              ];
            }
            {
              title = "Self: INK.Com";
              url = "https://www.inc.com/rss";
              tags = [
                "entrepreneur"
              ];
            }
            {
              title = "Self: Get Rich Slowly";
              url = "https://www.getrichslowly.org/feed/";
              tags = [
                "finance"
              ];
            }
            {
              title = "FOSS: FOSS Post";
              url = "https://fosspost.org/feed";
              tags = [
                "foss"
              ];
            }
            {
              title = "FOSS: FOSS Asia";
              url = "https://blog.fossasia.org/feed";
              tags = [
                "foss"
                "asia"
              ];
            }
            {
              title = "Coding: Better Programming";
              url = "https://medium.com/feed/better-programming";
              tags = [
                "programming"
              ];
            }
            {
              title = "Coding: A List Apart";
              url = "https://alistapart.com/main/feed";
              tags = [
                "webdev"
              ];
            }
            {
              title = "Coding: Tekmoji";
              url = "https://tekmoji.com/rss.xml";
              tags = [
                "programming"
              ];
            }
            {
              title = "Coding: Gyptazy";
              url = "https://gyptazy.com/feed/";
              tags = [
                "programming"
              ];
            }
            {
              title = "Coding: Scripting News";
              url = "http://scripting.com/rss.xml";
              tags = [
                "programming"
              ];
            }
            {
              title = "Coding: The Crazy Programmer";
              url = "https://thecrazyprogrammer.com/category/programming/feed";
              tags = [
                "programming"
              ];
            }
            {
              title = "Security: HackerNoon";
              url = "https://medium.com/feed/hackernoon";
              tags = [
                "programming"
              ];
            }
            {
              title = "Security: Hacker News";
              url = "https://hnrss.org/frontpage";
              tags = [
                "startup"
                "programming"
              ];
            }
            {
              title = "Security: Life Hacker";
              url = "https://lifehacker.com/feed/rss";
              tags = [
                "hack"
              ];
            }
            {
              title = "Company: Mozilla Hacks";
              url = "https://hacks.mozilla.org/feed";
              tags = [
                "mozilla"
              ];
            }
            {
              title = "Company: Github Blog";
              url = "https://github.blog/feed";
              tags = [
                "programming"
              ];
            }
            {
              title = "Company: JetBrains Blog";
              url = "https://blog.jetbrains.com/blog/feed/";
              tags = [
                "webdev"
              ];
            }
            {
              title = "Company: Engineering at Meta";
              url = "https://engineering.fb.com/feed/";
              tags = [
                "programming"
              ];
            }
            {
              title = "Company: Etsy Engineering";
              url = "https://www.etsy.com/codeascraft/rss";
              tags = [
                "programming"
              ];
            }
            {
              title = "Company: Engineering at Slack";
              url = "https://slack.engineering/feed";
              tags = [
                "programming"
              ];
            }
            {
              title = "Linux: LWN.net Linux Kernel";
              url = "https://lwn.net/headlines/newrss";
              tags = [
                "linux"
              ];
            }
            {
              title = "Linux: OMG! Ubuntu";
              url = "https://omgubuntu.co.uk/feed";
              tags = [
                "linux"
                "news"
              ];
            }
            {
              title = "Linux: Linux Journal";
              url = "https://www.linuxjournal.com/node/feed";
              tags = [
                "linux"
                "news"
              ];
            }
            {
              title = "Linux: It's FOSS";
              url = "https://itsfoss.com/rss/";
              tags = [
                "linux"
                "news"
              ];
            }
            {
              title = "Linux: BrixIT Blog";
              url = "https://blog.brixit.nl/rss";
              tags = [
                "linux"
                "news"
              ];
            }
            {
              title = "Linux: Lazybear Blog";
              url = "https://lazybea.rs/index.xml";
              tags = [
                "linux"
                "news"
              ];
            }
            {
              title = "Linux: Linux Audit";
              url = "https://linux-audit.com/feed";
              tags = [
                "linux"
                "news"
              ];
            }
            {
              title = "Data: KDnuggets";
              url = "https://www.kdnuggets.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Datafloq";
              url = "https://datafloq.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: SmartData Collective";
              url = "https://www.smartdatacollective.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Towards Data Science";
              url = "https://towardsdatascience.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Xtract.io Blog";
              url = "https://xtract.io/blog/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Statistical Modeling";
              url = "https://statmodeling.stat.columbia.edu/feed/";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Dataconomy";
              url = "https://dataconomy.com/feed/";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Databricks Blog";
              url = "https://www.databricks.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Analytics Vidhya";
              url = "https://www.analyticsvidhya.com/feed/";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Analytics Insight";
              url = "https://www.analyticsinsight.net/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Codementor";
              url = "https://www.codementor.io/community/topic/data-science/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Analytics India Magazine";
              url = "https://analyticsindiamag.com/ai-news-updates/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: DataFlair";
              url = "https://data-flair.training/blogs/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: DataRobot Blog";
              url = "https://www.datarobot.com/blog/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Amazon Science";
              url = "https://www.amazon.science/index.rss";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: InData Labs";
              url = "https://indatalabs.com/blog/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Verra Mobility";
              url = "https://www.verramobility.com/feed";
              tags = [
                "data-science"
              ];
            }
            # {
            #   title = "Data: NYC Data Science Academy";
            #   url = "https://nycdatascience.com/blog/feed";
            #   tags = [
            #    "data-science"
            #   ];
            # }
            {
              title = "Data: Seattle Data Guy";
              url = "https://www.theseattledataguy.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Little Miss Data";
              url = "https://www.littlemissdata.com/blog?format=RSS";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: SQL & Siva";
              url = "https://sqlandsiva.blogspot.com/feeds/posts/default";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data Science Unicorn";
              url = "https://datascienceunicorn.tumblr.com/rss";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Stats and R";
              url = "https://statsandr.com/index.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Dataversity";
              url = "https://www.dataversity.net/category/data-topics/data-science-data-topics/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Insight Extractor";
              url = "https://insightextractor.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: The Unofficial Google Data Science";
              url = "https://www.unofficialgoogledatascience.com/feeds/posts/default?alt=rss";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Win Vector LLC";
              url = "https://win-vector.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Dataaspirant";
              url = "https://dataaspirant.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Remix Institute";
              url = "https://www.remixinstitute.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: The SAS Data Science";
              url = "https://blogs.sas.com/content/subconsciousmusings/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Pete Warden's";
              url = "https://petewarden.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Machine Learning Mastery";
              url = "https://machinelearningmastery.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: O'Reilly";
              url = "https://www.oreilly.com/radar/feed";
              tags = [
                "data-science"
              ];
            }
            # {
            #   title = "Data: FlowingData"; # block by cloudflare
            #   url = "https://flowingdata.com/feed";
            #   tags = [
            #    "data-science"
            #   ];
            # }
            {
              title = "Data: Datanami";
              url = "https://www.datanami.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: BAIR Berkeley";
              url = "https://bair.berkeley.edu/blog/feed.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: R-bloggers";
              url = "https://feeds.feedburner.com/RBloggers";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Kaggle Blog";
              url = "https://medium.com/feed/kaggle-blog";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Ryan Swanstrom";
              url = "https://ryanswanstrom.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data Piques";
              url = "https://www.ethanrosenthal.com/index.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Hevo Data";
              url = "https://hevodata.com/blog/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Command Line Tips";
              url = "https://cmdlinetips.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: 9TO5SAS";
              url = "https://www.9to5sas.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Predictive Hacks";
              url = "https://predictivehacks.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Blue Orange";
              url = "https://blueorange.digital/blog/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Julia Silgi";
              url = "https://juliasilge.com/blog/index.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: AnyInstructor";
              url = "https://anyinstructor.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data For Science";
              url = "https://medium.data4sci.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data Science Switzerland";
              url = "https://blog.zhaw.ch/datascience/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Mad Data Scientist";
              url = "https://matloff.wordpress.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Socrates Data Science";
              url = "http://blog.socratesk.com/atom.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Carlo Carandang";
              url = "https://carlocarandang.com/category/data-science/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Nina B. Zumel";
              url = "https://ninazumel.com/feed.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Backyard Data Science";
              url = "https://buckwoody.wordpress.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data Plus Science";
              url = "https://www.dataplusscience.com/RSSfeed.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: DSI Analytic";
              url = "https://dsianalytics.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Algobeans";
              url = "https://algobeans.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Ranesh Badre";
              url = "https://www.reneshbedre.com/feed.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data Science SMU";
              url = "https://datascience.smu.edu/blog/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data Elixir";
              url = "https://dataelixir.com/issues.rss";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Ujjwal Karn";
              url = "https://ujjwalkarn.me/feed/";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: SV Data Science";
              url = "https://www.svds.com/blog/feed/";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Becoming Data Scientist";
              url = "https://www.becomingadatascientist.com/feed/";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: District Data Labs";
              url = "https://districtdatalabs.silvrback.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: DataQuest";
              url = "https://www.dataquest.io/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Python Blogger";
              url = "https://python-bloggers.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: DBT Labs";
              url = "https://www.getdbt.com/blog/feed.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Pragmatic Engineer";
              url = "https://newsletter.pragmaticengineer.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: SQL Authority";
              url = "https://blog.sqlauthority.com/feed/";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data Engineering Weekly";
              url = "https://www.dataengineeringweekly.com/feed";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Start Data Engineering";
              url = "https://www.startdataengineering.com/index.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Data is Plural";
              url = "https://www.data-is-plural.com/feed.xml";
              tags = [
                "data-science"
              ];
            }
            {
              title = "Data: Kahan Data Solutions";
              url = "https://www.kahandatasolutions.com/blog.rss";
              tags = [
                "data-science"
              ];
            }
          ];
        };
      };
    };
  };
}

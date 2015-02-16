(function() {
    var h = "10";
    var l = function(s) {
        if (!/^http:\/\/douban\.fm/.test(location.href) && window.console && window.console.log) {
            window.console.log(s)
        }
    };

    function e(s) {
        s = parseInt(s, 10);
        if (s === 0 || s === -9) {
            return "私人兆赫"
        } else {
            if (s === -3 || s === -8) {
                return "红心兆赫"
            } else {
                return $("#fm-channel-list .channel[cid=" + s + "] .chl_name").first().text()
            }
        }
    }

    function n(s) {
        window.ga && window.ga.apply(null, s)
    }

    function b(z, s, v, t, x, w, u) {
        var y = {
            id: z,
            artist: s,
            song_name: v,
            album: t,
            cover: x,
            timestamp: new Date().getTime(),
            channel: w,
            url: u
        };
        store.set("bubbler_song_info", y)
    }
    var m = window.navigator.userAgent.toLowerCase();
    var f = false;
    if (window.external && window.external.mxProductName) {
        f = true
    }
    if (!f || m.indexOf("maxthon") < 0) {
        var c = false,
            i, r = 60 * 1000,
            a = 180 * 60 * 1000;
        $("body").bind("mousemove", function() {
            c = true
        });
        setInterval(function() {
            if (c) {
                if (i) {
                    clearTimeout(i)
                }
                i = setTimeout(function() {
                    DBR.act("deactivate")
                }, a);
                c = false
            }
        }, r)
    }
    window.ropen = function(s, t) {
        if (t === "ScrollText") {
            n(["send", "event", "player", "clicked song name", s])
        } else {
            if (t === "RadioCover") {
                n(["send", "event", "player", "clicked cover", s])
            }
        }
        setTimeout(function() {
            window.open(s)
        }, 0)
    };
    window.trace = l;
    var o = $("#fm-rotate-ad").data("campaign-start").match(/(\d+)/g),
        j = $("#fm-rotate-ad").data("campaign-end").match(/(\d+)/g),
        q = {
            start: o && new Date(o[0], o[1] - 1, o[2]),
            end: j && new Date(j[0], j[1] - 1, j[2])
        };
    $("#rec-tip .rec-title").click(function() {
        var s = $(this).data("rec-url");
        (s !== "") && window.open(s)
    });
    var d = function(t, y) {
        var v = $("#rec-tip"),
            s = g[t];
        if (s !== undefined) {
            var u = {
                    1: "歌曲",
                    2: "艺术家"
                },
                x = u[s.rec_type],
                w = s.title;
            v.find(".rec-type").text(x);
            v.find(".rec-title").text(w).data("rec-url", s.url);
            v.show()
        } else {
            y && v.hide()
        }
    };
    var k = 0,
        g = {};
    window.extStatusHandler = function(v) {
        v = $.parseJSON(v);
        var t = v.type;
        var u = v.song;
        var s = {
            init: function(y) {
                var w = $(".ch-list-wrapper .channel[cid=" + y.channel + "]");
                if (w.attr("cid") <= 0) {
                    $("#recent_chls li").remove()
                }
                $("#recent_chls").show();
                if (!w.length) {
                    var z = ["#system_chls .channel:first", "#fav_chls .channel[cid=" + y.channel + "]", "#promotion_chls .channel[cid=" + y.channel + "]", "#history_chls .channel[cid=" + y.channel + "]", "#recent_chls .channel:not(.personal):first", "#promotion_chls .channel:first", "#ss-intros .ss-intro:first h3"];
                    for (var x = 0; x < z.length; x++) {
                        w = $(z[x]);
                        if (w.length) {
                            break
                        }
                    }
                }
                w.trigger("click", [true]);
                typeof rotatead != "undefined" && rotatead.refreshAd(w.data("cid"));
                window.show_pro_init_tip();
                window.show_pro_expire_tip()
            },
            gotoplay: function(x) {
                var w = k ? Math.floor((new Date() - k) / 1000) : 0;
                n(["send", "event", "player", "resume", "pause time", w]);
                typeof rotatead != "undefined" && rotatead.refreshAd(x.channel)
            },
            pause: function(w) {
                k = new Date();
                n(["send", "event", "player", "pause"])
            },
            start: function(A) {
                var w, y = A.channel;
                document.title = u.title + " - " + window.title_fixed;
                $("#simulate-sec").attr("schid", 2000000 + parseInt(u.sid));
                var x = y;
                if (!$("#com_songs_sec .ch_item[data-cid=" + y + "]").length) {
                    x = $("#simulate-sec").attr("schid") || y
                }
                if (u.subtype !== "T") {
                    w = globalConfig.pageHost + "/?start=" + u.sid + "g" + u.ssid + "g" + y + "&cid=" + x
                } else {
                    w = globalConfig.pageHost + "/?daid=" + u.sid + "&cid=" + x
                }
                curl = globalConfig.pageHost + "/?cid=" + y;
                d(u.sid, true);
                var z = setInterval(function() {
                    if (window.FM && window.FM.setCurrentSongInfo) {
                        window.FM.setCurrentSongInfo(u.title, y === h ? u.albumtitle : u.artist, e(y), w, curl, u.picture, null, u.sid, u.ssid, y);
                        clearInterval(z)
                    }
                }, 200);
                b(u.sid, u.artist, u.title, y === h ? u.albumtitle : u.artist, u.picture, e(y), w);
                if (bgad) {
                    bgad.set_adTheme(bgad.ad_theme_check(y))
                }
                if (u.songlists_count === 0) {
                    $("#fm-playlists").data("show", false).hide()
                } else {
                    $("#fm-playlists").data("show", true).show()
                }
            },
            r: function(w) {
                user_record.increase("liked");
                n(["send", "event", "Song", "Liked", window.flags.is_user_login ? "User" : "Anony"])
            },
            u: function(w) {
                user_record.decrease("liked");
                n(["send", "event", "Song", "UnLiked", window.flags.is_user_login ? "User" : "Anony"])
            },
            nl: function(w) {
                if (!w.playlist || !w.playlist.length) {
                    $(".channel[cid=0]").click()
                }
                g = {};
                if (w.channel && w.channel === "0") {
                    $.getJSON("/j/mine/rec_explanation", function(x) {
                        if (x && x.explanation) {
                            g = x.explanation;
                            var y = window.FM.getCurrentSongInfo();
                            y && y.id && d(y.id, false)
                        }
                    })
                }
                if (w.is_show_quick_start) {
                    window.fmQuickStart.open()
                }
            },
            e: function(y) {
                user_record.increase("played");
                var x = x || [];
                x.push(u.sid + ":p");
                x = x.slice(-3);
                set_cookie({
                    ra_r: x.join("|")
                });
                typeof skipTips != "undefined" && skipTips.resetCounter();
                var w = new Date();
                if (q && q.start && q.end && w >= q.start && w <= q.end) {
                    typeof rotatead != "undefined" && rotatead.refreshAd(y.channel)
                }
                $("#simulate-ready").hide();
                $("#simulate-btn").fadeIn()
            },
            b: function(w) {
                user_record.increase("banned");
                typeof skipTips != "undefined" && skipTips.incrCounter();
                $("#simulate-ready").hide();
                $("#simulate-btn").fadeIn();
                n(["send", "event", "Song", "Banned", window.flags.is_user_login ? "User" : "Anony"])
            },
            s: function(w) {
                typeof skipTips != "undefined" && skipTips.incrCounter();
                typeof rotatead != "undefined" && rotatead.refreshAd(w.channel);
                $("#simulate-ready").hide();
                $("#simulate-btn").fadeIn();
                n(["send", "event", "Song", "Skipped"])
            },
            fixchannel: function(w) {
                typeof skipTips != "undefined" && skipTips.channelChanged();
                typeof rotatead != "undefined" && rotatead.refreshAd(w.channel)
            }
        };
        $(window).trigger("radio:" + t, [v]);
        s[t](v);
        if (window.checkSiteModeBtn) {
            window.checkSiteModeBtn()
        }
    };
    window.DBR = {
        swf: function() {
            return document.getElementById("radioplayer")
        },
        act: function(u, s) {
            var t = DBR.swf();
            t.act.apply(t, arguments)
        },
        selected_like: function() {
            return DBR.swf().selectedLike()
        },
        is_paused: function() {
            return DBR.swf().isPaused()
        },
        set_kbps_manually: function(s) {
            return DBR.swf().setKbpsManually(s)
        },
        set_autokbps: function(s) {
            return DBR.swf().setAutoKbps(s)
        },
        get_autokbps: function() {
            return DBR.swf().getAutoKbps()
        },
        get_kbps: function() {
            return DBR.swf().getKbps()
        },
        suggest_kbps: function(s) {
            window.show_kbps_slow(s)
        },
        radio_getlist: function(s) {
            $.ajax({
                url: s,
                type: "GET",
                dataType: "text",
                timeout: 10000,
                error: function(w, v) {
                    var t = "";
                    try {
                        t = w.responseText
                    } catch (u) {
                        t = u.toString()
                    }
                    v += " js_fail ";
                    v += t.slice(0, 80);
                    DBR.swf().list_onerror("js_load_fail")
                },
                success: function(t) {
                    DBR.swf().list_onload(t)
                }
            });
            return "ok"
        },
        rlog: function(s) {
            l(s)
        },
        except_report: function(s) {
            $.get("/j/except_report?kind=ra006&env=" + navigator.userAgent + "+&reason=" + s)
        },
        show_login: function() {
            var s = globalConfig.doubanHost + "/service/account/check_with_js?" + $.param({
                return_to: globalConfig.login_check_url,
                sig: globalConfig.ajax_sig,
                r: Math.random()
            }) + "&callback=?";
            $.getJSON(s, function(t) {
                $.getJSON(t.url, function(u) {
                    if (u.r == 0) {
                        $(window).trigger(window.consts.LOGIN_EVENT, u.user_info)
                    } else {
                        show_login()
                    }
                })
            })
        },
        logout: function() {
            window.is_user_login = false;
            delete globalConfig.uid;
            $("#fm-header").find("#anony_nav").remove().end().find("#user_info").remove().end().prepend($.tmpl($("#tmpl_user_info").html(), {}))
        },
        play_video: function(w) {
            $("#v-player").remove();
            window.disableBannerAd();
            var x = $('<div id="v-player"><div id="fmvideo"></div></div>');
            x.insertBefore($("#fm-player"));
            $("#fm-player").css("top", "-1000px");
            window.fmQuickStart.hide();
            var y = {
                    wmode: "opaque"
                },
                t = {
                    link: encodeURIComponent(w.album),
                    src: w.url,
                    name: w.title || ""
                },
                u = {
                    id: "fmvideo",
                    name: "fmvideo"
                };
            swfobject.embedSWF("/swf/fmvideo.swf", "fmvideo", "560", "480", "9.0.0", "/swf/expressInstall.swf", t, y, u);
            if (w.monitor_url !== "") {
                var v = "",
                    s = Math.random();
                if (w.monitor_url.indexOf("?") !== -1) {
                    v = w.monitor_url + "&__ver=" + s
                } else {
                    v = w.monitor_url + "?__ver=" + s
                }
                $("body").append('<img class="monitor-url" src="' + v + '" width="0" height="0"/>')
            }
            return true
        },
        close_video: function() {
            $(".monitor-url").remove();
            if ($("#v-player").length) {
                window.enableBannerAd();
                var s = 0,
                    t = document.getElementById("fmvideo");
                if (t !== undefined) {
                    s = t.get_progress() || 0
                }
                $("#v-player").remove();
                $("#fm-player").css("top", "90px");
                window.fmQuickStart.show();
                DBR.swf().video_complete(s)
            }
            return DBR
        }
    };
    var p = function() {
        $.get("/j/new_captcha", function(s) {
            $('form.pop_win_login_form input[name="captcha_id"]').val(s);
            var t = "/misc/captcha?size=m&id=" + s;
            $("form.pop_win_login_form img.captcha").attr("src", t)
        }, "json")
    };
    window.show_login = function() {
        $.fn.loginFormCheck = function() {
            $("form.pop_win_login_form").submit(function() {
                if ($.trim($("input.pop_email").val()) === "") {
                    $("div.spec span.error").show()
                }
                if ($("span.error:visible").length) {
                    return false
                }
            })
        };
        $.get("/j/misc/login_form", function(t) {
            window.showGrayLayer();
            var u = dui.Dialog({
                    width: 555,
                    height: 300,
                    title: "登录",
                    isHideTitle: true,
                    iframe: 1,
                    content: t
                }).open(),
                s = u.node;
            p();
            s.find(".hd h3").replaceWith(s.find(".bd h3"));
            s.find("h3 a, form a").attr("target", "_blank");
            s.find("form").loginFormCheck();
            s.find("form.pop_win_login_form img.captcha").click(function() {
                p()
            });
            s.find("a.dui-dialog-close").bind("click", function() {
                $("div.overlay").remove()
            });
            s.bind("dialog:close", function() {
                $("div.overlay").remove()
            });
            $(window).bind(window.consts.LOGIN_EVENT, function() {
                u.close();
                $("div.overlay").remove()
            });
            u.update()
        });
        return false
    }
})();
(function(a, b) {
    if (typeof define === "function" && define.amd) {
        define(["jquery"], b)
    } else {
        a.abstrompts = b(window.$)
    }
}(this, function(f) {
    var d = {
            container: null,
            dataComponent: "a",
            selectComponent: "li"
        },
        c, j, g, a;

    function b(l) {
        var k = this;
        k.lastChosen = -1;
        h(k, l, d);
        k.container = f(k.container).bind("click", function(n) {
            var m = n.target;
            if (!f(m).is(k.dataComponent)) {
                j = true;
                return
            }
            n.preventDefault();
            k.outputText(m);
            k.outputData(m)
        })
    }
    b.prototype = {
        generateQuery: null,
        performQuery: null,
        render: null,
        beforeOpen: function() {},
        beforeClose: function() {},
        select: function(k) {
            f(k).addClass("chosen")
        },
        unselect: function(k) {
            f(k).removeClass("chosen")
        },
        outputText: null,
        outputData: function() {},
        show: function() {
            var k = this;
            k.outputData();
            k.fetch(function(l) {
                if (!l.length) {
                    return k.hide()
                }
                k.update(l);
                if (c !== k) {
                    k.open()
                }
            })
        },
        hide: function() {
            if (c !== this) {
                return false
            }
            this.close();
            return true
        },
        next: function() {
            if (c !== this) {
                return false
            }
            this.outputText(this.roam());
            return true
        },
        prev: function() {
            if (c !== this) {
                return false
            }
            this.outputText(this.roam(true));
            return true
        },
        fetch: function(k) {
            var m = this;
            var l = +new Date();
            m.close();
            a = l;
            clearTimeout(g);
            g = setTimeout(function() {
                var n = m.generateQuery();
                m.performQuery(n, function(o) {
                    if (a !== l) {
                        return
                    }
                    k(o)
                })
            }, 100)
        },
        update: function(k) {
            this.container.html(this.render(k))
        },
        roam: function(m) {
            var l = this.container.find(this.selectComponent);
            if (this.lastChosen >= 0) {
                this.unselect(l[this.lastChosen]);
                if (m) {
                    this.lastChosen--;
                    if (this.lastChosen < 0) {
                        this.lastChosen = l.length - 1
                    }
                } else {
                    this.lastChosen++;
                    if (this.lastChosen + 1 > l.length) {
                        this.lastChosen = 0
                    }
                }
            } else {
                this.lastChosen = 0
            }
            var k = l.eq(this.lastChosen);
            this.select(k[0]);
            k = k.find(this.dataComponent)[0];
            this.outputData(k);
            return k
        },
        open: function() {
            this.beforeOpen();
            if (c) {
                c.close()
            }
            c = this;
            this.container.show();
            f(document).bind("click", i)
        },
        close: function() {
            this.beforeClose();
            c = null;
            this.lastChosen = -1;
            a = 0;
            this.container.hide()
        }
    };

    function i() {
        if (j) {
            j = false;
            return
        }
        if (c) {
            c.close()
        }
        f(document).unbind("click", i)
    }

    function h(k, n, m) {
        for (var l in m) {
            if (m.hasOwnProperty(l)) {
                k[l] = n[l];
                if (typeof k[l] === "undefined") {
                    k[l] = m[l]
                }
            }
        }
    }

    function e(k) {
        var l = new e.Abstrompts(k);
        h(l, k, e.Abstrompts.prototype);
        return l
    }
    e.Abstrompts = b;
    return e
}));
(function(a, b) {
    if (typeof define === "function" && define.amd) {
        define(["jquery", "abstrompts", "DBR"], b)
    } else {
        a.fmQuickStart = b(a.$, a.abstrompts, a.DBR)
    }
}(this, function(i, H, m) {
    if (!Array.prototype.map) {
        Array.prototype.map = function(L, M) {
            for (var K = 0, N = [], J = this.length; K < J; K++) {
                if (K in this) {
                    N[K] = L.call(M, this[K], K, this)
                }
            }
            return N
        }
    }
    var g = {
            16: "shift",
            17: "ctrl",
            18: "alt",
            20: "capslock",
            224: "meta",
            8: "backspace",
            13: "return",
            27: "esc",
            9: "tab",
            37: "left",
            38: "up",
            39: "right",
            40: "down"
        },
        k = {
            alt: 1,
            ctrl: 1,
            shift: 1,
            meta: 1,
            capslock: 1,
            left: 1,
            right: 1
        },
        B = "/j/fm_newuser_guide_action_log",
        q = /\{\query\}/,
        f = "placeholder" in document.createElement("input"),
        u = i.getJSON,
        b = i.getJSON,
        c = i.template(null, i("#tmpl_quickstart").html()),
        h = i.template(null, i("#tmpl_quickstart_search").html()),
        t, y, I, C, v, j = 0;
    var G = {
        open: function() {
            if (t && t[0]) {
                return this.show()
            }
            u("/j/explore/get_newuser_artist_genre", function(J) {
                if (!J.genres) {
                    return
                }
                if (J.genres.length > 12) {
                    J.genres.length = 12
                }
                F(J)
            })
        },
        show: function() {
            if (t) {
                t.show()
            }
        },
        hide: function() {
            if (t) {
                t.hide()
            }
        },
        close: function() {
            if (t) {
                t.remove();
                t = null
            }
        }
    };

    function F(J) {
        t = i(i.tmpl(c, J));
        e();
        t.appendTo("#fm-section");
        y = t.find(".query");
        t.find("form").submit(function(K) {
            K.preventDefault()
        });
        i(window).bind("resize", e);
        setTimeout(function() {
            t.addClass("opening");
            d();
            s();
            if (!f) {
                n()
            }
            setTimeout(function() {
                t.addClass("opened")
            }, 2200);
            w(B, {
                action: "s"
            })
        }, 20)
    }

    function e() {
        var K = i(".player-wrap"),
            J = K.offset();
        t.css({
            top: J.top + K.height()
        })
    }

    function d() {
        t.delegate(".close", "click", function(J) {
            J.preventDefault();
            G.close();
            w(B, {
                action: "c"
            })
        }).delegate(".play", "click", function(L) {
            L.preventDefault();
            var M = p();
            if (!M[0]) {
                var J = i(this).parent().find(".text");
                var K = x(J);
                if (K) {
                    b(K, function(N) {
                        var O = N[0];
                        if (!O) {
                            return z()
                        }
                        z(J.attr("logtype") + (O.id || O.cid) + "|" + O.ssid, O.title || O.name)
                    })
                } else {
                    z()
                }
            } else {
                z.apply(this, M)
            }
        }).delegate(".artist", "click", function(K) {
            K.preventDefault();
            var J = i(this);
            if (!J[0].href) {
                J = J.closest("a")
            }
            if (C) {
                C.removeClass("chosen")
            }
            C = J.addClass("chosen");
            D("sa" + l(J[0].href), J.attr("title"));
            J.closest(".choose").find(".text").focus().val(J.attr("title")).blur()
        }).delegate(".tag", "click", function(J) {
            J.preventDefault();
            if (v) {
                v.removeClass("chosen")
            }
            v = i(this).addClass("chosen");
            D("sg" + l(this.href), i(this).attr("title"))
        }).delegate(".prev", "click", function(J) {
            J.preventDefault();
            j--;
            A(i(this).parent())
        }).delegate(".next", "click", function(J) {
            J.preventDefault();
            j++;
            A(i(this).parent())
        }).delegate(".mask", "click", o)
    }

    function s() {
        t.find(".text").each(function() {
            var K = i(this);
            var L = i('<div class="search-results"></div>').css({
                top: K[0].offsetTop + K.height(),
                left: K[0].offsetLeft
            }).insertAfter(K);
            var J = H({
                container: L,
                dataComponent: "a.title",
                selectComponent: "li",
                generateQuery: function() {
                    return x(K)
                },
                performQuery: function(N, M) {
                    if (N) {
                        b(N, M)
                    }
                },
                render: function(M) {
                    return i.tmpl(h, {
                        results: M
                    })
                },
                beforeClose: function() {
                    t.find(".search-results").hide()
                },
                outputText: function(M) {
                    K.val(M.innerHTML)
                },
                outputData: function(N) {
                    var M = N ? l(N.href) : "";
                    D(M && (K.attr("logtype") + M), N && N.innerHTML)
                }
            });
            K.bind("keydown", function(N) {
                var M = g[N.which || N.keyCode];
                switch (M) {
                    case "esc":
                        J.hide();
                        break;
                    case "return":
                        if (J.hide()) {
                            N.preventDefault()
                        }
                        break;
                    case "tab":
                        if (J.next()) {
                            N.preventDefault()
                        }
                        break;
                    case "down":
                        if (J.next()) {
                            N.preventDefault()
                        }
                        break;
                    case "up":
                        if (J.prev()) {
                            N.preventDefault()
                        }
                        break;
                    default:
                        if (!k[M]) {
                            J.show()
                        }
                }
            })
        })
    }

    function A(J) {
        var M = J.find(".prev");
        var L = J.find(".next");
        var K = Math.ceil(t.find("a.artist").length / 4);
        if (j <= 0) {
            j = 0;
            M.hide()
        } else {
            M.show()
        }
        if (j >= K - 1) {
            j = K - 1;
            L.hide()
        } else {
            L.show()
        }
        a(j);
        w(B, {
            action: "t"
        })
    }

    function a(J) {
        var K = t.find(".artist-list");
        K.animate({
            scrollLeft: J * K.width()
        }, 400)
    }

    function o(J) {
        J.preventDefault();
        if (I) {
            I.addClass("disabled")
        }
        I = i(this).parent().removeClass("disabled");
        D(false)
    }

    function D(K, J) {
        y.val(K || "").data("name", J || "");
        if (!K) {
            if (C) {
                C.removeClass("chosen")
            }
            if (v) {
                v.removeClass("chosen")
            }
        }
    }

    function p() {
        return [y.val(), y.data("name")]
    }

    function l(J) {
        return J.replace(/.*#/, "")
    }

    function z(M, J) {
        var K = M && /^(\D+)(\d+)(\|.+)?/.exec(M) || [];
        var L = (K[3] || "").substr(1);
        M = parseFloat(K[2]);
        K = K[1];
        if (K === "sg" || K === "sa" || K === "qa") {
            m.close_video().act("switch", M)
        } else {
            if (K === "qs") {
                E("start", [M, L, M + 2000000].join("g"));
                M += 2000000;
                m.close_video().act("switch", M)
            } else {
                window.alert("没有找到相关兆赫，试试输入其他关键字");
                return
            }
        }
        i(window).trigger("channel:switch", [{
            id: M,
            name: J
        }]);
        w(B, {
            action: "l",
            detail: [K, M].join("|")
        });
        G.close()
    }

    function x(K) {
        var J = K.val();
        if (!/\S/.test(J)) {
            return ""
        }
        return K.attr("api").replace(q, J)
    }

    function n() {
        t.find(".text").each(function() {
            var J = i(this).blur(function() {
                if (!/\S/.test(this.value)) {
                    K.show()
                } else {
                    K.hide()
                }
            });
            var L = J.attr("placeholder");
            var K = i('<label class="text-tips">' + L + "</label>").css({
                left: J[0].offsetLeft,
                top: J[0].offsetTop
            }).insertAfter(J).click(function() {
                K.hide();
                J.focus()
            })
        })
    }

    function w(K, L) {
        var J = new Image();
        J.onload = function() {
            J = null
        };
        J.src = !L ? K : [K, /\?/.test(K) ? "&" : "?", typeof L == "string" ? L : r(L)].join("")
    }

    function r(J) {
        var M = [];
        if (J.constructor == Array) {
            for (var L = 0; L < J.length; L++) {
                M.push(J[L].name + "=" + encodeURIComponent(J[L].value))
            }
        } else {
            for (var K in J) {
                M.push(K + "=" + encodeURIComponent(J[K]))
            }
        }
        return M.join("&").replace(/%20/g, "+")
    }

    function E(K, J) {
        window.document.cookie = [K, "=", encodeURIComponent(J), "", "", "; domain=douban.fm"].join("")
    }
    return G
}));
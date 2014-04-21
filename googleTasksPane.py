import gtk
import webkit
import gobject

def destroy(widget, data=None):
    gtk.main_quit()

gobject.threads_init()
window = gtk.Window()
scroller = gtk.ScrolledWindow()
browser = webkit.WebView()

window.set_title("My Task List") #sets the window title
window.resize(350, 1024) #sets the window size
window.add(scroller)
scroller.add(browser)
browser.open("https://mail.google.com/tasks/ig?pli=1") #sets the url of the webapp

window.connect("destroy", destroy)
window.show_all()
gtk.main()

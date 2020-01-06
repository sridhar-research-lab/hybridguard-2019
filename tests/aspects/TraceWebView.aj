import org.aspectj.lang.JoinPoint;
import android.webkit.WebView;
import android.util.Log;

public aspect TraceWebView{
    before() : within(android.webkit..*) && ! within(TraceWebView) {
        Log.d("UD-UNCC-TraceWebView", "Enter: " +thisJoinPoint);
    }
    after() : within(android.webkit..*) && ! within(TraceWebView){
        Log.d("UD-UNCC-TraceWebView", "Exit: " +thisJoinPoint);
    }
}

import org.aspectj.lang.JoinPoint;
import android.util.Log;

public aspect loadURLPolicy {
    pointcut loadURLPointCut(String url) : call(* *.loadUrl(String))&& args(url);  
    void around(String url) : loadURLPointCut(url)
    {
    	Log.d("UD-UNCC","call="+thisJoinPoint.getSignature()+";source="+thisJoinPoint.getSourceLocation()+";url="+url);
        proceed(url);         
    }
}  

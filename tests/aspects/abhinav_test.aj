
import android.util.Log;



public aspect Aspectlogger {
	
	pointcut log(String url): cflow(call(* *.loadUrl(String))) && args(url) && !cflow(within(Aspectlogger));
	
	before(String url): log(url){
		Log.d("UD-UNCC","call="+thisJoinPoint.getSignature()+";source="+thisJoinPoint.getSourceLocation()+ "url:" + url );
        //Log.d("AspectLogger J","logBefore() is running!");
        Log.d("AspectLogger J","hijacked : " + thisJoinPoint.getSignature().getName());
	}
}
	
	